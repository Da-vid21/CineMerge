import UIKit

class ViewController: UIViewController, UITableViewDataSource {
    var folders: [Folder] = []
    
    
    
    @IBOutlet weak var folderTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        folderTable.dataSource = self
        
        // Create test folders
        folders = createTestFolders()
        
        // Store folders in UserDefaults
        do {
            let encodedData = try JSONEncoder().encode(folders)
            UserDefaults.standard.set(encodedData, forKey: "foldersKey")
        } catch {
            print("Error encoding folders:", error)
        }
    }
    
    func createTestFolders() -> [Folder] {
        var testFolders: [Folder] = []
        
        let colors: [UIColor] = [.red, .blue, .green, .yellow, .purple, .orange, .cyan, .magenta]
        
        for i in 1...15 {
            let folderName = "Folder \(i)"
            let colorIndex = i % colors.count // Use color from predefined array cyclically
            let color = colors[colorIndex]
            let folderColor = FolderColor(uiColor: color)
            let folder = Folder(folderName: folderName, folderColor: folderColor)
            testFolders.append(folder)
        }
        
        return testFolders
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 15
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        let folder = folders[indexPath.row]
        
        // Configure the cell
        cell.textLabel?.text = folder.folderName
        cell.imageView?.image = UIImage(named: "folder")
        cell.backgroundColor? = folder.folderColor.uiColor
        
        return cell
    }
}

struct Folder: Codable {
    var folderName: String
    var folderColor: FolderColor
}

struct FolderColor: Codable {
    var red: CGFloat
    var green: CGFloat
    var blue: CGFloat
    var alpha: CGFloat
    
    var uiColor: UIColor {
        return UIColor(red: red, green: green, blue: blue, alpha: alpha)
    }
    
    init(uiColor: UIColor) {
        var red: CGFloat = 0.0
        var green: CGFloat = 0.0
        var blue: CGFloat = 0.0
        var alpha: CGFloat = 0.0
        uiColor.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        self.red = red
        self.green = green
        self.blue = blue
        self.alpha = alpha
    }
}
