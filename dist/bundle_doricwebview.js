'use strict';

Object.defineProperty(exports, '__esModule', { value: true });

var doric = require('doric');

var __decorate = (undefined && undefined.__decorate) || function (decorators, target, key, desc) {
    var c = arguments.length, r = c < 3 ? target : desc === null ? desc = Object.getOwnPropertyDescriptor(target, key) : desc, d;
    if (typeof Reflect === "object" && typeof Reflect.decorate === "function") r = Reflect.decorate(decorators, target, key, desc);
    else for (var i = decorators.length - 1; i >= 0; i--) if (d = decorators[i]) r = (c < 3 ? d(r) : c > 3 ? d(target, key, r) : d(target, key)) || r;
    return c > 3 && r && Object.defineProperty(target, key, r), r;
};
var __metadata = (undefined && undefined.__metadata) || function (k, v) {
    if (typeof Reflect === "object" && typeof Reflect.metadata === "function") return Reflect.metadata(k, v);
};
var __awaiter = (undefined && undefined.__awaiter) || function (thisArg, _arguments, P, generator) {
    function adopt(value) { return value instanceof P ? value : new P(function (resolve) { resolve(value); }); }
    return new (P || (P = Promise))(function (resolve, reject) {
        function fulfilled(value) { try { step(generator.next(value)); } catch (e) { reject(e); } }
        function rejected(value) { try { step(generator["throw"](value)); } catch (e) { reject(e); } }
        function step(result) { result.done ? resolve(result.value) : adopt(result.value).then(fulfilled, rejected); }
        step((generator = generator.apply(thisArg, _arguments || [])).next());
    });
};
class WebView extends doric.View {
    evaluateJavaScript(context, script) {
        return __awaiter(this, void 0, void 0, function* () {
            const ret = yield this.nativeChannel(context, "evaluateJavaScript")(script);
            return ret;
        });
    }
}
__decorate([
    doric.Property,
    __metadata("design:type", String)
], WebView.prototype, "url", void 0);
__decorate([
    doric.Property,
    __metadata("design:type", String)
], WebView.prototype, "content", void 0);
__decorate([
    doric.Property,
    __metadata("design:type", Boolean)
], WebView.prototype, "allowJavaScript", void 0);
function webView(config) {
    const ret = new WebView();
    ret.layoutConfig = doric.layoutConfig().fit();
    if (config) {
        ret.apply(config);
    }
    return ret;
}

exports.WebView = WebView;
exports.webView = webView;
//# sourceMappingURL=bundle_doricwebview.js.map
