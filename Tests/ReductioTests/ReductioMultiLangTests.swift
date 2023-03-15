//
//  File.swift
//  
//
//  Created by Rei Kitajima on 2023/03/14.
//

import Foundation
@testable import Reductio
import XCTest

final class ReductioMultiLangTests: XCTestCase {

    // MARK: This text is an extract and translated from http://www.theverge.com/2016/3/28/11284590/oculus-rift-vr-review

    let str = "Oculusは、自社の工業デザインを自慢することはほとんどありませんが、その中でも特に優れているのは、ステレオタイプでオタク的なものを（比較的）自然に見せていることです。599ドルのコンシューマー向けRiftは、巧妙で思慮深いタッチに満ちています。まず、ゴム製の柔らかなキャリングケースが同梱されており、これによって全体がサイバーパンクのハッカー向けゲーム機のように感じられます。オールブラックのヘッドセットは、ゲームハードウェアの基準からすると非常に控えめで、前面は滑らかなゴム製、側面は粗い布でコーティングされ、レンズはライクラの網で囲まれています。PCとの接続は1本のワイヤーで行われ、左のこめかみから調節可能なサイドストラップの1本を通っています。ウィリアム・ギブソンのバーチャルリアリティへの挑戦は「ニューロマンサー」が有名ですが、Riftは、デザインに傾倒した彼の小説「パターン・リコグニション」に登場するような、ブランド嫌いのクールな主人公ケイシー・ポラードが認めるようなミニマルな製品に感じられます。Riftを正しくフィットさせるのは、最初は難しいかもしれません。底部に小さなフォーカスノブがありますが、スクリーンの鮮明さの多くは、目に対してどのように角度をつけるかに左右されます。しかし、装着に慣れてくると、このヘッドセットは他の競合製品よりも軽く、快適で、しっかりとした、しかししなやかなフォームのリングで顔に密着するように感じられます。Riftでまだ汗をかいたことがないので、お手入れのしやすさは分かりませんが、リングは取り外して交換できます（ただし、予備は付属していません）。私はメガネをかける必要はありませんが、メガネをかけているVergeの同僚は好意的な反応を示しています。彼らは適度なサイズのフレームにヘッドセットを装着するか、処方箋によってはメガネなしでスクリーンに焦点を合わせることができます。Riftには、8インチの細長いスタンドに取り付けられた円筒形の黒いトラッキングカメラとともに、Xbox OneゲームパッドとOculus Remoteと呼ばれる小型でシンプルなデバイスという2つのアクセサリーが付属しています。ソニーやHTCとは異なり、Oculusは今年の後半にOculus Touchハードウェアが登場するため、Riftに独自のフルコントローラーを付けて発売することはない。今のところ、洗練されたRiftのデザインと並んで、ずっしりとしたカラフルなXboxのゲームパッドは、少し場違いな感じがします。それとは対照的に、楕円形の黒いリモコンは、システムの他の部分ほどしっかりした作りには感じられませんが、しっくりと馴染んでいます。Riftは、リビングルームに置いても満足できるもので、かつての開発者向けのOculusデバイスと比べると、セットアップが簡単です。4メートルのヘッドセットテザーの先にはUSBポートとHDMIポートが1つずつあり、トラッキングカメラも専用のUSBケーブルで接続します（いずれも外部電源ケーブルやコントローラーボックスはありません）。OculusのWindowsアプリをダウンロードし、VRに入る前に、簡単な、しかし説明的なセットアップのチェックリストを実行するだけです。もちろん、ここまで来るには強力なゲーミングデスクトップが必要であり、それだけでも多くの不具合が発生する可能性があります。また、ほとんどのPCにはHDMIポートが1つしかないため、モニターには別の接続を使用する必要があり、多くの人にとって余分で直感的でないステップとなります。しかし、ほとんどの場合、まったく新しい種類のコンピューターハードウェアをインストールすることは、想像できるほど簡単です。"
    
    let maxIteration: Int = 200

	var context:ReductioContext { return ReductioContext(text: str, maxIteration: maxIteration) }

    lazy var keywords: [String] = Reductio.executeKeywords(context: context)
    lazy var summarize: [String] = Reductio.executeSummarizer(context: context)

    func testHasKeywords() {
        XCTAssertNotNil(keywords)
    }

    func testEmptyTextKeywords() {
    	let context = ReductioContext(text: "", maxIteration: maxIteration)
        XCTAssert(Reductio.executeKeywords(context: context).isEmpty)
    }

    func testTextContainsKeywords() {
        XCTAssert(keywords.contains("oculus"))
        XCTAssert(keywords.contains("rift"))
        XCTAssert(keywords.contains("headset"))
    }

    func testTextContainsSameKeywords() {
        let expectation = self.expectation(description: "expect same keywords with different API")

		Reductio.keywords(from: str, maxIteration: maxIteration) { words in
            XCTAssertEqual(words, self.keywords)
            expectation.fulfill()
        }

        waitForExpectations(timeout: 1.0, handler:nil)
    }

    func testReductioKeywordsWithCounter() {
        let expectation = self.expectation(description: "expect five keywords for text")

		Reductio.keywords(from: str, count: 5, maxIteration: maxIteration) { words in
            XCTAssertEqual(words.count, 5)
            expectation.fulfill()
        }

        waitForExpectations(timeout: 1.0, handler:nil)
    }

    func testReductioKeywordsWithCompression() {
        let expectation = self.expectation(description: "expect all keywords for text")

        Reductio.keywords(from: str, maxIteration: maxIteration, compression: 0) { words in
            XCTAssertEqual(words, self.keywords)
            expectation.fulfill()
        }

        waitForExpectations(timeout: 1.0, handler:nil)
    }

    func testReductioKeywordsWithOutboundsCompression() {
        let expectation = self.expectation(description: "no expect any keywords for text")

        Reductio.keywords(from: str, maxIteration: maxIteration, compression: 2.0) { words in
            XCTAssert(words.isEmpty)
            expectation.fulfill()
        }

        waitForExpectations(timeout: 1.0, handler:nil)
    }

    func testHasSummarize() {
        XCTAssertNotNil(summarize)
    }

    func testReductioSummarizeWithCounter() {
        let expectation = self.expectation(description: "expect five sentences from summarize")

        Reductio.summarize(text: str, maxIteration: maxIteration, count: 5) { words in
            XCTAssertEqual(words.count, 5)
            expectation.fulfill()
        }

        waitForExpectations(timeout: 1.0, handler:nil)
    }

    func testReductioSummarizeWithCompression() {
        let expectation = self.expectation(description: "expect first sentence of summarize")

        Reductio.summarize(text: str, maxIteration: maxIteration, compression: 0.95) { sentence in
            XCTAssertEqual(sentence.count, 1)
            expectation.fulfill()
        }

        waitForExpectations(timeout: 1.0, handler:nil)
    }

}

