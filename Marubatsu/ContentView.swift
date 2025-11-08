//
//  ContentView.swift
//  Marubatsu
//
//  Created by Sayaka Sasaki on 2025/11/08.
//

import SwiftUI

//クイズの構造体(本当であれば別ファイルで入れたい)
struct Quiz: Identifiable, Codable {
    var id = UUID()
    var question: String
    var answer: Bool
}


struct ContentView: View {
    
    // 問題文の表示
    let quizExamples: [Quiz] = [
        Quiz(question: "iPhoneアプリを開発する統合環境はZcodeである", answer: false),
        Quiz(question: "Xcode画面の右側にはユーティリティーズがある", answer: true),
        Quiz(question: "Textは文字列を表示する際に利用する", answer: true)
    ]
    
    @State var currentQuestionNum: Int = 0 //今、何問目の数字かを表示
    @State var showingAlert = false//アラートの表示、非表示の管理
    @State var alertTitle = ""//正解、不正解の文字を入れる用の変数
    
    var body: some View {
        GeometryReader{ geometry in
            VStack {
                Text(showQuestion())
                    .padding()
                    .frame(width: geometry.size.width * 0.85, alignment: .leading) //横幅を親ビューの横幅の0.85倍に、左寄せに。
                    .font(.system(size: 25))
                    .fontDesign(.rounded)
                    .background(.yellow)
                
                Spacer()
                
                HStack{
                    //丸ボタン
                    Button {
                        checkAnswer(yourAnswer: true)
                    } label: {
                        Text("O") //ボタンの見た目
                    }
                    .frame(width: geometry.size.width * 0.4, height: geometry.size.width * 0.4)//横幅と高さを親ビューの横幅の０．４倍に指定
                    .font(.system(size: 100,weight: .bold))
                    .foregroundStyle(.white)
                    .background(.red)
                    
                    //バツボタン
                    Button {
                        checkAnswer(yourAnswer: false)
                    } label: {
                        Text("X") //ボタンの見た目
                    }
                    .frame(width: geometry.size.width * 0.4, height: geometry.size.width * 0.4)//横幅と高さを親ビューの横幅の０．４倍に指定
                    .font(.system(size: 100,weight: .bold))
                    .foregroundStyle(.white)
                    .background(.blue)
                }
                
            }
            .padding()
            .frame(width: geometry.size.width, height: geometry.size.height) //左端のずれを直す
            
            //回答時のアラート
            .alert(alertTitle, isPresented: $showingAlert) {
                Button("OK", role: .cancel){}
            }
        }
    }
    //問題を表示する関数
    func showQuestion() -> String{
        //配列から〇〇問目の問題文を表示する
        let question = quizExamples[currentQuestionNum].question
        return question
    }
    
    //回答をチェックする関数、正解したら次の問題を表示し、次がない時は０へ戻る
    func checkAnswer(yourAnswer: Bool) {
        let quiz = quizExamples[currentQuestionNum] //表示されてるクイズを取り出す
        let ans = quiz.answer//クイズから回答を取り出す
        if yourAnswer == ans { //正解の時、一つすすむ
            alertTitle = "正解"
            
            if currentQuestionNum + 1 < quizExamples .count {
                currentQuestionNum += 1
            } else {
                currentQuestionNum = 0
            }
            //if文が終わった後にアラートを表示させる
        } else {
            alertTitle = "不正解"
        }
        showingAlert = true
    }
    
}//ContentViewがここまで

#Preview {
    ContentView()
}
