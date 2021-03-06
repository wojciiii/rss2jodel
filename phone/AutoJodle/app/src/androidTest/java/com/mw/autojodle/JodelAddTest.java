package com.mw.autojodle;

/**
 * Created by wojci on 11/18/17.
 */

import android.content.Context;
import android.content.Intent;
import android.os.Bundle;
import android.support.test.InstrumentationRegistry;
import android.support.test.filters.SdkSuppress;
import android.support.test.runner.AndroidJUnit4;
import android.support.test.uiautomator.By;
import android.support.test.uiautomator.UiCollection;
import android.support.test.uiautomator.UiDevice;
import android.support.test.uiautomator.UiObject;
import android.support.test.uiautomator.UiSelector;
import android.support.test.uiautomator.Until;
import android.util.Base64;
import android.util.Log;
import android.view.KeyCharacterMap;
import android.view.KeyEvent;

import org.junit.Before;
import org.junit.Test;
import org.junit.runner.RunWith;

import java.text.SimpleDateFormat;
import java.util.Date;

import static org.hamcrest.core.IsNull.notNullValue;
import static org.junit.Assert.assertThat;

@RunWith(AndroidJUnit4.class)
@SdkSuppress(minSdkVersion = 18)
public class JodelAddTest {
    private static final String TAG = JodelAddTest.class.getSimpleName();

    private static final String BASIC_SAMPLE_PACKAGE
            = "com.tellm.android.app";
    /* com.tellm.android.app/ */

    private static final int LAUNCH_TIMEOUT = 5000;
    private static final String STRING_TO_BE_TYPED = "UiAutomator";
    private UiDevice mDevice;

    private boolean mGotHash;
    private String mHash;

    private boolean mGotText;
    private String mText;

    static KeyCharacterMap mCharMap;

    @Before
    public void startMainActivityFromHomeScreen() {

        try {
            Bundle extras = InstrumentationRegistry.getArguments();

            String input1 = extras.getString("input_string1");

            Log.d(TAG, "Got input1: " + input1);

            byte[] data = Base64.decode(input1, Base64.DEFAULT);
            mHash = new String(data, "UTF-8");
            Log.d(TAG, "Got hash: " + mHash);
            mGotHash = true;
        } catch (Exception e) {
            mGotHash = false;
            mHash = "";
            Log.e(TAG, "Error:" + e.toString());
        }

        try {
            Bundle extras = InstrumentationRegistry.getArguments();

            String input2 = extras.getString("input_string2");

            Log.d(TAG, "Got input2: " + input2);

            byte[] data = Base64.decode(input2, Base64.DEFAULT);
            mText = new String(data, "UTF-8");
            Log.d(TAG, "Got text: " + mText);
            mGotText = true;
        } catch (Exception e) {
            mGotText = false;
            mText = "No text";
            Log.e(TAG, "Error:" + e.toString());
        }

        // Initialize UiDevice instance
        mDevice = UiDevice.getInstance(InstrumentationRegistry.getInstrumentation());

        // Start from the home screen
        mDevice.pressHome();

        // Wait for launcher
        final String launcherPackage = mDevice.getLauncherPackageName();
        assertThat(launcherPackage, notNullValue());
        mDevice.wait(Until.hasObject(By.pkg(launcherPackage).depth(0)),
                LAUNCH_TIMEOUT);

        // Launch the app
        Context context = InstrumentationRegistry.getContext();
        final Intent intent = context.getPackageManager().getLaunchIntentForPackage(BASIC_SAMPLE_PACKAGE);
        // Clear out any previous instances
        //intent.addFlags(Intent.FLAG_ACTIVITY_CLEAR_TASK);
        context.startActivity(intent);

        // Wait for the app to appear
        mDevice.wait(Until.hasObject(By.pkg(BASIC_SAMPLE_PACKAGE).depth(0)),
                LAUNCH_TIMEOUT);

        mCharMap = KeyCharacterMap.load(KeyCharacterMap.VIRTUAL_KEYBOARD);
    }

    static int defaultWait = 1000;

    static KeyEvent[] getEvents(String input) {
        KeyEvent[] events = mCharMap.getEvents(input.toCharArray());

        return events;
    }

    @Test
    public void testJodelAddNewPost() {
        if (!mGotText) {
            Log.d(TAG, "mGotText = " + mGotText);
            return;
        }

        UiObject imageBtn = new UiCollection(new UiSelector()
                .resourceId("com.tellm.android.app:id/add_post_button"));

        try {
            imageBtn.click();
        }
        catch (Exception e) {
            Log.d(TAG, "Exception: " + e.toString());
        }

        imageBtn.waitUntilGone(defaultWait);

        UiObject text = new UiCollection(new UiSelector()
                .resourceId("com.tellm.android.app:id/create_post_edit_text"));

        UiObject hashtag = new UiCollection(new UiSelector()
                .resourceId("com.tellm.android.app:id/hashtag_prompt_edit_text"));

        UiObject sendBtn = new UiCollection(new UiSelector()
                .resourceId("com.tellm.android.app:id/toolbar_send"));

        SimpleDateFormat dateFormat = new SimpleDateFormat("HH:mm:ss");
        String string  = dateFormat.format(new Date());

        KeyEvent events[] = getEvents(mText);

        try {
            text.clearTextField();
            text.setText(mText);

            if (mGotHash) {
                hashtag.setText("#"+mHash);
            }
            sendBtn.click();
        }
        catch (Exception e) {
            Log.d(TAG, "Exception: " + e.toString());
        }

        mDevice.waitForIdle();
    }

}