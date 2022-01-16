import UIKit
import PDFKit

class ContentsTableViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            let nib = UINib(nibName: Constants.Identifiers.customCell, bundle: nil)
            tableView.register(nib, forCellReuseIdentifier: Constants.Identifiers.customCell)
            tableView.delegate = self
            tableView.dataSource = self
        }
    }
    
    var selectedDroneName: Name?
    var sectionsContent = [SectionsContent]()
    
    private var contentSlideNames = [String]()
    private var contentLabelsText = [String]()
    private var rowIndex = Int()
    private var rowSection = Int()
    private var contentVc: ContentViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        splitViewController?.delegate = self
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        switch segue.identifier {
        case Constants.Segues.toProgramStepContent:
            guard let destination = segue.destination as? ContentViewController else { return }
            contentVc = destination
            updateUiForContentVc(destination: contentVc)
            assignClosuresForContentVc()
//        case Constants.Segues.toFAQ:
//            guard let destinationVC = segue.destination as? FAQViewController else { return }
//            destinationVC.selectedFaqStepIndex = rowIndex
        default:
            break
        }
    }
    
    private func moveToContentVc() {
        if UIScreen.main.traitCollection.horizontalSizeClass == .regular {
            guard let destination = splitViewController?.viewController(for: .secondary) as? ContentViewController else { return }
            contentVc = destination
            updateUiForContentVc(destination: contentVc)
            assignClosuresForContentVc()
            splitViewController?.hide(.primary)
        }
        else {
            performSegue(withIdentifier: Constants.Segues.toProgramStepContent, sender: nil)
        }
    }
    
    //MARK: Keep tableView in sync with slide on screen
    
    private func syncTableViewWithSlideOnScreen() {
        tableView.selectRow(at: IndexPath(row: rowIndex, section: rowSection), animated: true, scrollPosition: UITableView.ScrollPosition.middle)
    }
    
    private func assignClosuresForContentVc() {
        contentVc?.didTapNext = { [weak self] in
            if self?.rowIndex != (self?.contentSlideNames.endIndex)! - 1 {
                self?.rowIndex += 1
            }
            self?.updateUiForContentVc(destination: (self?.contentVc))
            self?.syncTableViewWithSlideOnScreen()
        }
        contentVc?.didTapPrevious = { [weak self] in
            if self?.rowIndex != self?.contentSlideNames.startIndex {
                self?.rowIndex -= 1
            }
            self?.updateUiForContentVc(destination: (self?.contentVc))
            self?.syncTableViewWithSlideOnScreen()
        }
    }
}

extension ContentsTableViewController {
    
    // MARK: Prepare slides and labels for ContentViewController
    
    private func prepareDataSourceFromSelectedRow(at indexPath: IndexPath) {
        rowIndex = indexPath.row
        rowSection = indexPath.section
        contentSlideNames.removeAll()
        contentLabelsText.removeAll()
        guard let selectedDroneNameString = selectedDroneName?.rawValue else { return }
        for currentSlide in sectionsContent {
            if let slideName = currentSlide as? QuickStartGuideSectionContent, slideName != .FAQ {
                contentSlideNames.append(selectedDroneNameString + "\(slideName)")
                contentLabelsText.append("\(slideName)")
            }
            else {
                contentSlideNames.append(selectedDroneNameString + "\(currentSlide)")
                contentLabelsText.append("\(currentSlide)")
            }
        }
    }
    
    // MARK: Update UI in ContentViewController
    
    private func updateUiForContentVc(destination vc: ContentViewController?) {
        if vc?.view == nil {
            let _ = vc?.view
        }
        vc?.backgroundVideoView.isHidden = true
        vc?.uiWasUpdated = true
        guard let url = Bundle.main.url(forResource: contentSlideNames[rowIndex], withExtension: "pdf") else { return }
        guard let pdfDocument = PDFDocument(url: url) else { return }
        vc?.pdfView.document = pdfDocument
        vc?.pdfView.autoScales = true
        vc?.pdfView.goToFirstPage(nil)
        
        vc?.contentLabel.text = contentLabelsText[rowIndex].localized
        vc?.contentLabel.adjustsFontSizeToFitWidth = true
        
        vc?.previousSlideBtn.titleLabel?.adjustsFontSizeToFitWidth = true
        vc?.previousSlideBtn.setTitleColor(.systemRed, for: .normal)
        
        vc?.nextSlideBtn.titleLabel?.adjustsFontSizeToFitWidth = true
        vc?.nextSlideBtn.setTitleColor(.systemRed, for: .normal)
        
        switch rowIndex {
        case contentSlideNames.endIndex - 1:
            vc?.nextSlideBtn.isUserInteractionEnabled = false
            vc?.nextSlideBtn.setTitle("", for: .normal)
            vc?.previousSlideBtn.isUserInteractionEnabled = true
            vc?.previousSlideBtn.setTitle("< " + "\(LocalizedKeys.BtnTitles.previousBtn)", for: .normal)
        case contentSlideNames.startIndex:
            vc?.nextSlideBtn.isUserInteractionEnabled = true
            vc?.nextSlideBtn.setTitle("\(LocalizedKeys.BtnTitles.nextBtn)" + " >", for: .normal)
            vc?.previousSlideBtn.isUserInteractionEnabled = false
            vc?.previousSlideBtn.setTitle("", for: .normal)
        default:
            vc?.nextSlideBtn.isUserInteractionEnabled = true
            vc?.nextSlideBtn.setTitle("\(LocalizedKeys.BtnTitles.nextBtn)" + " >", for: .normal)
            vc?.previousSlideBtn.isUserInteractionEnabled = true
            vc?.previousSlideBtn.setTitle("< " + "\(LocalizedKeys.BtnTitles.previousBtn)", for: .normal)
        }
    }
}

extension ContentsTableViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sectionsContent.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.Identifiers.customCell, for: indexPath) as? MyTableViewCell else { return UITableViewCell() }
        let content = sectionsContent[indexPath.row]
        cell.itemLabel.text = "\(indexPath.row+1)."
        cell.titleLabel.text = "\(content)".localized
        cell.descriptionLabel.text = nil
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let selectedRow = sectionsContent[indexPath.row] as? QuickStartGuideSectionContent {
            switch selectedRow {
            case .FAQ:
                performSegue(withIdentifier: Constants.Segues.toFAQ, sender: nil)
            default:
                prepareDataSourceFromSelectedRow(at: indexPath)
                moveToContentVc()
            }
        }
        else {
            prepareDataSourceFromSelectedRow(at: indexPath)
            moveToContentVc()
        }
    }
}

extension ContentsTableViewController: UISplitViewControllerDelegate {
    
    func splitViewController(_ svc: UISplitViewController, topColumnForCollapsingToProposedTopColumn proposedTopColumn: UISplitViewController.Column) -> UISplitViewController.Column {
        
        //        if let secondaryColumnVc = secondaryColumnVc {
        //            let _ = (svc.viewController(for: .compact) as? UINavigationController)?.pushViewController(secondaryColumnVc, animated: false)
        //        }
        return proposedTopColumn
    }
    
    func splitViewController(_ svc: UISplitViewController, displayModeForExpandingToProposedDisplayMode proposedDisplayMode: UISplitViewController.DisplayMode) -> UISplitViewController.DisplayMode {
        
        //        if let secondaryColumnVc = secondaryColumnVc {
        //            if let compactNav = svc.viewController(for: .compact) as? UINavigationController {
        //                if let _ = compactNav.viewControllers.last as? ContentViewController {
        //                    compactNav.popViewController(animated: false)
        //                }
        //            }
        //            DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
        //                let nav = UINavigationController(rootViewController: secondaryColumnVc)
        //                svc.setViewController(nav, for: .secondary)
        //            }
        //        }
        return .oneOverSecondary
    }
}
