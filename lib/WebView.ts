import { BridgeContext, View, Property, layoutConfig } from "doric";

export class WebView extends View {
  @Property
  url?: string;
  @Property
  content?: string;
  /**
   * Enables or disables file access within WebView.
   * File access is disabled by default.
   * Note that this enables or disables file system access only.
   * Assets and resources are still accessible using file:///android_asset and file:///android_res.
   */
  @Property
  allowFileAccess?: boolean;
  /**
   * Tells WebView to enable JavaScript execution. The default is true.
   */
  @Property
  allowJavaScript?: boolean;

  async evaluateJavaScript(context: BridgeContext, script: string) {
    const ret = await this.nativeChannel(context, "evaluateJavaScript")(script);
    return ret as string;
  }
}

export function webView(config?: Partial<WebView>) {
  const ret = new WebView();
  ret.layoutConfig = layoutConfig().fit();
  if (config) {
    ret.apply(config);
  }
  return ret;
}
