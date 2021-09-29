import {
  createRef,
  Panel,
  Group,
  layoutConfig,
  navbar,
  jsx,
  VLayout,
  Text,
} from "doric";
import { WebView } from "doric-webview";
import { loge } from "doric/lib/src/util/log";

@Entry
class Example extends Panel {
  onShow() {
    navbar(context).setTitle("Example");
  }
  build(rootView: Group) {
    const webRef = createRef<WebView>();
    <VLayout parent={rootView} layoutConfig={layoutConfig().most()}>
      <Text layoutConfig={layoutConfig().mostWidth().justHeight()} height={50}>
        Web Content
      </Text>
      <WebView
        ref={webRef}
        layoutConfig={layoutConfig().mostWidth().justHeight().configWeight(1)}
        url="https://doric.pub"
      />
    </VLayout>;
    setTimeout(async () => {
      const ret = await webRef.current.evaluateJavaScript(
        this.context,
        `JSON.stringify(window.performance.timing)`
      );
      loge(ret);
    }, 2000);
  }
}
