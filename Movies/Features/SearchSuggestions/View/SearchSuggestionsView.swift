import UIKit
import Combine

protocol SearchSuggestionViewDelegate: AnyObject {
    func didSelectSuggestion(_ text: String)
}

final class SearchSuggestionView: UIView {

    weak var delegate: SearchSuggestionViewDelegate?

    private let viewModel = SearchSuggestionViewModel()
    private var cancellables = Set<AnyCancellable>()

    private let tableView: UITableView = {
        let tv = UITableView()
        tv.backgroundColor = .clear
        tv.separatorStyle = .none
        tv.isHidden = true
        tv.layer.cornerRadius = 12
        tv.clipsToBounds = true
        tv.showsVerticalScrollIndicator = true
        tv.isScrollEnabled = true
        tv.bounces = true
        tv.alwaysBounceVertical = true  // ✅ Always allow vertical bounce
        return tv
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        bindViewModel()
    }

    required init?(coder: NSCoder) { fatalError() }

    private func setupUI() {
        self.clipsToBounds = false
        self.backgroundColor = .clear
        
        addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: topAnchor),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])

        tableView.register(SearchSuggestionCell.self,
                           forCellReuseIdentifier: SearchSuggestionCell.id)
        tableView.delegate = self
        tableView.dataSource = self
    }

    private func bindViewModel() {
        viewModel.$suggestions
            .receive(on: RunLoop.main)
            .sink { [weak self] items in
                guard let self = self else { return }
                self.tableView.isHidden = items.isEmpty
                self.tableView.reloadData()
                
                // ✅ Force layout update after reload
                DispatchQueue.main.async {
                    self.tableView.layoutIfNeeded()
                }
            }
            .store(in: &cancellables)
    }

    // MARK: - Public
    func update(text: String) {
        viewModel.filter(text: text)
    }

    func showAll() {
        viewModel.showAll()
        tableView.isHidden = false
        tableView.reloadData()
        
        // ✅ Ensure it's interactive
        self.isUserInteractionEnabled = true
        tableView.isUserInteractionEnabled = true
    }
}

// MARK: - Table Delegates
extension SearchSuggestionView: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfItems()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }

    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: SearchSuggestionCell.id,
            for: indexPath
        ) as? SearchSuggestionCell else {
            return UITableViewCell()
        }

        let item = viewModel.item(at: indexPath.row)
        cell.configure(title: item.title)
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let item = viewModel.item(at: indexPath.row)
        delegate?.didSelectSuggestion(item.title)
        tableView.isHidden = true
    }
}
