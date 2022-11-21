//
//  AlertVC.swift
//  Zawidha
//
//  Created by Maher on 10/12/20.
//

import UIKit

class AlertVC: UIViewController {
    
    //Outlets
    @IBOutlet weak var yesOptionalTypeBttn: UIButton!
    @IBOutlet weak var noOptionalTypeBttn: UIButton!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var bodyView: UIView!
    @IBOutlet weak var emojiImage: UIImageView!
    @IBOutlet weak var stackButtons: UIStackView!
    @IBOutlet weak var okBtn: UIButton!
    @IBOutlet weak var bodyLbl: UILabel!
    
    //Variables
    var completionHandler : ((Bool)->())?
    var alert_Title = ""
    var alert_Body = ""
    var alert_Status : Alert_Status = .failure
    var alert_Type : Alert_Type = .single
    
    var emojiImageName =  ""
    var okBtnTitle = ""
    var noOptionalTypeBttnText = "لا"
    var yesOptionalTypeBttnText = "نعم"
    
    // MARK: - ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        setup_Style()
    }
    
    // MARK: - ViewWillAppear
    override func viewWillAppear(_ animated: Bool) {
        animate_IN()
        self.okBtn.setTitle(okBtnTitle, for: .normal)
        self.okBtn.titleLabel?.font = UIFont.init(name: "Cairo-Bold", size: 17)
        self.emojiImage.image = UIImage.init(named: emojiImageName)
        self.noOptionalTypeBttn.setTitle(noOptionalTypeBttnText, for: .normal)
        self.yesOptionalTypeBttn.setTitle(yesOptionalTypeBttnText, for: .normal)
    }
    
    // MARK: - Setup Style
    private func setup_Style() {
        bodyView.transform = CGAffineTransform(translationX: 0, y: 600)
        set_Blur(containerView: self.view)
        bodyLbl.text = alert_Body
        titleLbl.text = alert_Title
        if alert_Type == .optional {
            stackButtons.alpha = 1
            okBtn.alpha = 0
        } else {
            stackButtons.alpha = 0
            okBtn.alpha = 1
        }
    }
    
    // MARK: - OK Button
    @IBAction func ok_Button(_ sender: Any) {
        animate_Out(success: true)
    }
    
    // MARK: - Animate IN
    private func animate_IN() {
        UIView.animate(withDuration: 0.3, delay: 0.2, options: .transitionCrossDissolve, animations: {[weak self] in
            guard let self = self else { return }
            self.bodyView.transform = .identity
        }, completion: nil)
        
//        animate(withDuration: 0.3, animations: 0.2, completion: {[weak self] in
//            guard let self = self else { return }
//            self.bodyView.transform = .identity
//        })
    }
    
    // MARK: - Animate Out
    private func animate_Out(success : Bool) {
        UIView.animate(withDuration: 0.3, animations: {[weak self] in
            guard let self = self else { return }
            self.bodyView.transform = CGAffineTransform(translationX: 0, y: 600)
        }, completion: {[weak self] (_) in
            self?.dismiss(animated: true, completion: nil)
            self?.completionHandler?(success)
        })
//        UIView.animate(withDuration: 0.3) {[weak self] in
//            guard let self = self else { return }
//            self.bodyView.transform = CGAffineTransform(translationX: 0, y: 600)
//        } completion: {[weak self] (_) in
//            self?.dismiss(animated: true, completion: nil)
//            self?.completionHandler?(success)
//        }
    }
    
    // MARK: - Yes Button
    @IBAction func yes_Button(_ sender: Any) {
        animate_Out(success: true)
    }
    
    // MARK: - No Button
    @IBAction func no_Button(_ sender: Any) {
        animate_Out(success: false)
    }
    

}

// MARK: - Alert Status
enum Alert_Status {
    case failure , success
}

// MARK: - Alert Type
enum Alert_Type {
    case optional , single
}
