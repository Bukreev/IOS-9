

import Foundation

struct AlgorithmRepository {
    let storage: AlgorithmsStorage
    let provider: AlgorithmItemsProvider
    
    init(storage: AlgorithmsStorage, provider: AlgorithmItemsProvider) {
        self.storage = storage
        self.provider = provider
    }
    
    func getItems(completion: ([AlgorithmItem])->()) {
        if storage.isCacheExist() {
            storage.getCachedData(completion)
        } else {
            provider.getRemoteAlgorithmItems{ items in
                storage.cacheData(items)
                completion(items)
            }
        }
    }
    
    func cacheData(_ items:[AlgorithmItem]){
        storage.cacheData(items)
    }
    
}
