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
    
    @AppStorage("Quiz") var quizzesData = Data() //UserDefoltsから問題を読み込む（Data型）
    @State var quizzesArray: [Quiz] = []//問題を入れておく配列
    
    @State var currentQuestionNum: Int = 0 //今、何問目の数字かを表示
    @State var showingAlert = false//アラートの表示、非表示の管理
    @State var alertTitle = ""//正解、不正解の文字を入れる用の変数
    
    //起動時にquizzesDataを読み込んだData型の値を[Quiz]型にデコード
    init(){
        if let decoderdQuizzes = try? JSONDecoder().decode([Quiz].self, from: quizzesData){
            _quizzesArray = State(initialValue: decoderdQuizzes)
        }
    }
    
    var body: some View {
        NavigationStack{
            
            GeometryReader{ geometry in
                VStack {
                    Text(showQuestion())
                        .padding()
                        .frame(width: geometry.size.width * 0.85, alignment: .leading) //横幅を親ビューの横幅の0.85倍に、左寄せに。
                        .font(.system(size: 25))
                        .fontDesign(.rounded)
                        .background(.brown)
                        .cornerRadius(10)
                    
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
                        .background(.pink)
                        
                        //バツボタン
                        Button {
                            checkAnswer(yourAnswer: false)
                        } label: {
                            Text("X") //ボタンの見た目
                        }
                        .frame(width: geometry.size.width * 0.4, height: geometry.size.width * 0.4)//横幅と高さを親ビューの横幅の０．４倍に指定
                        .font(.system(size: 100,weight: .bold))
                        .foregroundStyle(.white)
                        .background(.gray)
                    }
                    
                }
                .padding()
                .frame(width: geometry.size.width, height: geometry.size.height) //左端のずれを直す
                .navigationTitle("まるばつクイズ")
                //回答時のアラート
                .alert(alertTitle, isPresented: $showingAlert) {
                    Button("OK", role: .cancel){}
                }
                
                //問題作成画面へ遷移するためのボタンを設置
                .toolbar{
                    //配置する場所を画面最上部のバーの右端に設定
                    ToolbarItem(placement: .topBarLeading){
                        NavigationLink {
                            //遷移先の画面
                            CreateView(quizzesArray: $quizzesArray)
                                .navigationTitle("問題を作ろう!")
                        } label: {
                            //画面に遷移するためのボタンのみた目
                            Image(systemName: "plus")
                                .font(.title)
                            //Text("問題を作る")
                        }
                    }
                }
            }
        }
    }
    //問題を表示する関数
    func showQuestion() -> String{
        var question = "問題がありません！"
        
        //問題があるかどうかのチェック
        if !quizzesArray.isEmpty{ //quizzesArrayが空ではない時（問題が存在する時）！で否定する
            let quiz = quizzesArray[currentQuestionNum]
            question = quiz.question
        }
        return question
    }
    
    //回答をチェックする関数、正解したら次の問題を表示し、次がない時は０へ戻る
    func checkAnswer(yourAnswer: Bool) {
        if quizzesArray.isEmpty { return } //問題がない時
        let quiz = quizzesArray[currentQuestionNum] //表示されてるクイズを取り出す
        let ans = quiz.answer//クイズから回答を取り出す
        if yourAnswer == ans { //正解の時、一つすすむ
            alertTitle = "正解"

            if currentQuestionNum + 1 < quizzesArray .count {
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
