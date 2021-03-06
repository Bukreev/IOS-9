

import UIKit

class BenchmarkViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBAction func autoUploadToggled(_ sender: UISwitch) {
        if sender.isOn {
            viewModel.isAutoUpdateChart = true
        } else {
            viewModel.isAutoUpdateChart = false
        }
    }
    
    var viewModel = BenchmarkViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCollectionCellWidth()
        setupSwitch()
        
        viewModel.bind{[unowned self] (state) in
            switch(state){
            case .idle:
                self.collectionView.reloadData()
                break
            case .result:
                self.updateCell(IndexPath(row: self.viewModel.updatedRow, section: 0))
                break
            default:
                break
            }
        }
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        viewModel.unBind()
    }
    
    private func setupCollectionCellWidth() {
        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            let itemWidth = view.bounds.width
            let itemHeight = layout.itemSize.height
            layout.itemSize = CGSize(width: itemWidth, height: itemHeight)
            layout.invalidateLayout()
        }
    }

    private func updateCell(_ indexPath:IndexPath? ) {
        guard let path = indexPath else { return }
        if let cellView = collectionView.cellForItem(at: path) as? TimerViewCell {
            cellView.timerItem = viewModel.timers[path.row]
            if(viewModel.isAutoUpdateChart) {
                cellView.updatePieChart()
            }
        }
    }
    
    private func setupSwitch() {
        let updateSwitch = UISwitch(frame: .zero)
        updateSwitch.isOn = self.viewModel.isAutoUpdateChart
        updateSwitch.addTarget(self, action: #selector(autoUploadToggled(_:)), for: .valueChanged)
        let switchItem = UIBarButtonItem(customView: updateSwitch)
        navigationItem.rightBarButtonItem = switchItem
    }
}
