import Foundation
import Network

final class NetworkMonitor {
    
    static let shared = NetworkMonitor()
    private let queue = DispatchQueue.global(qos: .background)
    private let monitor = NWPathMonitor()
    
    public private(set) var isConnected = false
    
    public func startMonitoring() {
        monitor.start(queue: queue)
        monitor.pathUpdateHandler = { [weak self] path in
            if path.status != .satisfied {
                self?.isConnected = false
            }
            else {
                self?.isConnected = true
            }
        }
    }
    
    public func stopMonitoring() {
        monitor.cancel()
    }
}
