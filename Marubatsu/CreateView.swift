//
//  ContentView.swift
//  Marubatsu
//
//  Created by Sayaka Sasaki on 2025/11/08.
//

import SwiftUI

struct CreateView: View {
    
    @Binding var quizzesArray: [Quiz] //回答画面で読み込んだ問題を受け取る
    @State private var questionText = ""
    @State private var selectedAnswer = "O" //ピッカーで選ばれた解答を受け取る
    let answers = ["O", "X"] // ピッカーの選択肢
    
    var body: some View {
        VStack {
            Text("問題文と解答を入力して、追加ボタンを押してください")
                .foregroundStyle(.gray)
                .padding()
            
            TextField(text: $questionText){
                Text("問題文を入力してください")
            }
            .padding()
            .textFieldStyle(.roundedBorder)
            
            //解答を選択するピッカー
            Picker("", selection: $selectedAnswer) {
                ForEach(answers, id: \.self) { answer in
                    Text(answer)
                }
            }
            .pickerStyle(.segmented)
            .frame(maxWidth: 300)
            .padding()
            
            //追加ボタン
            Button("追加"){
                //追加ボタンが押された時の処理
                addQuiz(question: questionText, answer: selectedAnswer)
            }
            .padding()
            
            //全削除ボタン
            Button {
                quizzesArray.removeAll()
                UserDefaults.standard.removeObject(forKey: "Quiz")
            } label: {
                Text("全削除")
            }
            .foregroundStyle(.red)
            .padding()
            
            //問題と回答リスト（List）
            List {
                ForEach(quizzesArray) { quiz in
                    HStack {
                        Text(quiz.question)
                        Text(quiz.answer ? "○" : "×")
                    }
                }
                // 並び替え、削除
                .onMove(perform: replaceRow)
                .onDelete (perform: deleteQuiz)
            }
            .toolbar {
                EditButton()
            }
        }
        // アプリ起動時に保存データを読み込む
        .onAppear {
            loadSavedQuizzes()
        }
    }
    
    //並び替えの関数
    func replaceRow(_ from: IndexSet, _ to: Int) {
        quizzesArray.move(fromOffsets: from, toOffset: to)
        saveQuizzes()
    }
    
    // 削除の関数
    func deleteQuiz(offsets: IndexSet) {
        quizzesArray.remove(atOffsets: offsets)
        saveQuizzes()
    }
    
    //問題追加（保存）の関数
    func addQuiz(question: String, answer: String) {
        if question.isEmpty {
            print("問題文が入力されていません") //未入力の時
            return }
        
        //保存するためのtrue falseを入れておく変数
        var savingAnswer = true
        //OかXかでtrue falseを切り替える
        switch answer {
        case "O":
            savingAnswer = true
        case "X":
            savingAnswer = false
        default:
            print("適切な答えが入っていません")
            break
        }
        //これから入力する問題をインスタンス化
        let newQuiz = Quiz(question: question, answer: savingAnswer)
        
        var array = quizzesArray //読み込んだ問題をを一時的に別の配列へ
        array.append(newQuiz)//作った問題を配列に追加
        let storeKey = "Quiz"//UserDefoltsに保存するためのキー
        
        //エンコードできたら保存
        if let encordedQuizzes = try? JSONEncoder().encode(array) {
            UserDefaults.standard.setValue(encordedQuizzes, forKey: storeKey)//保存処理
            questionText = ""//テキストフィールドを空白に戻す
            quizzesArray = array //[既存問題 + 新問題]となった配列に更新
            print(array)
        }
    }
    //保存処理
    func saveQuizzes() {
        let storeKey = "Quiz"
        if let encodedQuizzes = try? JSONEncoder().encode(quizzesArray) {
            UserDefaults.standard.set(encodedQuizzes, forKey: storeKey)
        }
    }
    
    //読み込み処理
    func loadSavedQuizzes() {
        let storeKey = "Quiz"
        if let savedData = UserDefaults.standard.data(forKey: storeKey),
           let decoded = try? JSONDecoder().decode([Quiz].self, from: savedData) {
            quizzesArray = decoded
        }
    }
}

//#Preview {
//    CreateView()
//}
