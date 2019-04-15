//: [Previous](@previous)

//: # The ATM User Interface Example
import Foundation

protocol ATMUI {}

protocol BraileUI: ATMUI {}
protocol ScreenUI: ATMUI {}
protocol SpeechUI: ATMUI {}

//: ATM Transaction Hierarchy
protocol Transaction {
    func execute()
}
protocol Deposit: Transaction {}
protocol Withdraw: Transaction {}
protocol Transfer: Transaction {}

class UI {
    var deposit: Deposit?
    var withdraw: Withdraw?
    var transfer: Transfer?
}

//: Segregated ATM Interfaces
protocol DepositUI {
    func requestDepositAmount()
}
protocol DepositTransaction: Transaction {
    var ui: DepositUI { get }
}
extension DepositTransaction {
    func execute() {
        // Prepare for transaction
        ui.requestDepositAmount()
        // do transaction
    }
}

protocol WithdrawUI {
    func requestWithdrawAmount()
}
protocol WithdrawTransaction: Transaction {
    var ui: WithdrawUI { get }
}
extension WithdrawTransaction {
    func execute() {
        // Prepare for transaction
        ui.requestWithdrawAmount()
        // do transaction
    }
}

protocol TransferUI {
    func requestTransferAmount()
}
protocol TransferTransaction: Transaction {
    var ui: TransferUI { get }
}
extension TransferTransaction {
    func execute() {
        // Prepare for transaction
        ui.requestTransferAmount()
        // do transaction
    }
}

class MultipleInheritanceUI: DepositUI, WithdrawUI, TransferUI {
    func requestDepositAmount() {}
    func requestWithdrawAmount() {}
    func requestTransferAmount() {}
}

//: One of the issues with ISP is that each interface needs to know his particular version of the UI. But this could be addressed having a module that provide those pieces like:

struct DrawUI {
    static var depositUI: DepositUI!
}
/*:
 ```
extension DepositTransaction {
    func execute() {
        // Prepare for transaction
        DrawUI.depositUI
            .requestDepositAmount()
        // do transaction
    }
}
 ```
 */

//: Other consideration came when considering functions

func doSomething(_ deposit: DepositUI,
                 _ transfer: TransferUI) {}
// VS
func doSomethingElse(ui: DepositUI & TransferUI) {}

//: Althouhgt the first one seems wrong knowing is going to be call like:
let ui = MultipleInheritanceUI()
doSomething(ui, ui)
//: In the future it may be separated objects. From the point of view of the function that the interfaces are combined into a single object is not information that the function need to know.


