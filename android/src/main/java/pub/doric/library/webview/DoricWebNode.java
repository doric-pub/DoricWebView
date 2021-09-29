package pub.doric.library.webview;

import android.annotation.SuppressLint;
import android.os.Build;
import android.webkit.ValueCallback;
import android.webkit.WebChromeClient;
import android.webkit.WebSettings;
import android.webkit.WebView;
import android.webkit.WebViewClient;
import android.widget.ScrollView;

import com.github.pengfeizhou.jscore.JSValue;
import com.github.pengfeizhou.jscore.JavaValue;

import java.io.File;

import pub.doric.DoricContext;
import pub.doric.extension.bridge.DoricMethod;
import pub.doric.extension.bridge.DoricPlugin;
import pub.doric.extension.bridge.DoricPromise;
import pub.doric.shader.ViewNode;

/**
 * @Description: WebView
 * @Author: pengfei.zhou
 * @CreateDate: 2021/9/29
 */
@DoricPlugin(name = "WebView")
public class DoricWebNode extends ViewNode<WebView> {

    private final WebChromeClient webChromeClient = new WebChromeClient();

    private final WebViewClient webViewClient = new WebViewClient();

    public DoricWebNode(DoricContext doricContext) {
        super(doricContext);
    }

    @SuppressLint("SetJavaScriptEnabled")
    @Override
    protected WebView build() {
        WebView webView = new WebView(getContext());
        WebSettings settings = webView.getSettings();
        settings.setBuiltInZoomControls(false);
        settings.setSupportZoom(false);
        settings.setSaveFormData(false);
        settings.setSavePassword(false);
        settings.setUseWideViewPort(true);
        settings.setLoadWithOverviewMode(true);
        settings.setLoadsImagesAutomatically(true);
        settings.setJavaScriptEnabled(true);
        settings.setJavaScriptCanOpenWindowsAutomatically(true);
        settings.setDomStorageEnabled(true);
        settings.setDatabaseEnabled(true);
        try {
            settings.setDatabasePath(getContext().getApplicationContext().getDatabasePath("DoricWebView").getAbsolutePath());
            settings.setAppCacheEnabled(true);
            settings.setAppCachePath(getContext().getApplicationContext().getCacheDir().getAbsolutePath()
                    + File.separator + "DoricWebView");
        } catch (Throwable ignore) {
        }
        settings.setCacheMode(WebSettings.LOAD_DEFAULT);
        settings.setGeolocationEnabled(true);

        settings.setAllowFileAccess(false);
        settings.setAllowFileAccessFromFileURLs(false);
        settings.setAllowUniversalAccessFromFileURLs(false);

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
            settings.setMixedContentMode(WebSettings.MIXED_CONTENT_ALWAYS_ALLOW);
        }
        if (Build.VERSION.SDK_INT > 16) {
            try {
                settings.setMediaPlaybackRequiresUserGesture(false);
            } catch (Exception ignored) {
            }
        }

        webView.setWebChromeClient(webChromeClient);
        webView.setWebViewClient(webViewClient);
        webView.setScrollBarStyle(ScrollView.SCROLLBARS_INSIDE_OVERLAY);
        return webView;
    }

    @Override
    protected void blend(WebView view, String name, JSValue prop) {
        switch (name) {
            case "url":
                if (prop.isString()) {
                    view.loadUrl(prop.asString().value());
                }
                break;
            case "content":
                if (prop.isString()) {
                    view.loadData(prop.asString().value(), "text/html", "UTF-8");
                }
                break;
            case "allowFileAccess":
                if (prop.isBoolean()) {
                    WebSettings settings = view.getSettings();
                    settings.setAllowFileAccess(prop.asBoolean().value());
                    settings.setAllowFileAccessFromFileURLs(prop.asBoolean().value());
                    settings.setAllowUniversalAccessFromFileURLs(prop.asBoolean().value());
                }
                break;
            case "allowJavaScript":
                if (prop.isBoolean()) {
                    WebSettings settings = view.getSettings();
                    settings.setJavaScriptEnabled(prop.asBoolean().value());
                }
                break;
            default:
                super.blend(view, name, prop);
                break;
        }
    }

    @DoricMethod
    public void evaluateJavaScript(String script, final DoricPromise promise) {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.KITKAT) {
            mView.evaluateJavascript(script, new ValueCallback<String>() {
                @Override
                public void onReceiveValue(String value) {
                    promise.resolve(new JavaValue(value));
                }
            });
        }
    }
}
