import Foundation
import StoreKit

/// StoreKit 2 wrapper for the single "Remove Ads" non-consumable.
/// In development the products come from Products.storekit (selected in the
/// run scheme), so no App Store Connect setup is needed to test purchases.
@MainActor
final class StoreManager: ObservableObject {
    static let removeAdsID = "com.driftiq.solarempire.removeads"

    @Published private(set) var removeAdsProduct: Product?
    @Published private(set) var adsRemoved = false
    @Published private(set) var purchaseInProgress = false

    private var updatesTask: Task<Void, Never>?

    init() {
        updatesTask = Task { [weak self] in
            for await update in Transaction.updates {
                await self?.handle(update)
            }
        }
        Task {
            await self.loadProducts()
            await self.refreshEntitlements()
        }
    }

    func loadProducts() async {
        do {
            let products = try await Product.products(for: [Self.removeAdsID])
            removeAdsProduct = products.first
        } catch {
            removeAdsProduct = nil
        }
    }

    func refreshEntitlements() async {
        for await result in Transaction.currentEntitlements {
            if case .verified(let transaction) = result,
               transaction.productID == Self.removeAdsID,
               transaction.revocationDate == nil {
                adsRemoved = true
            }
        }
    }

    func purchaseRemoveAds() async {
        guard let product = removeAdsProduct, !purchaseInProgress else { return }
        purchaseInProgress = true
        defer { purchaseInProgress = false }
        do {
            let result = try await product.purchase()
            switch result {
            case .success(let verification):
                if case .verified(let transaction) = verification {
                    adsRemoved = true
                    await transaction.finish()
                }
            case .userCancelled, .pending:
                break
            @unknown default:
                break
            }
        } catch {
            // Purchase failed; the UI simply stays in the unpurchased state.
        }
    }

    func restore() async {
        try? await AppStore.sync()
        await refreshEntitlements()
    }

    private func handle(_ result: VerificationResult<Transaction>) async {
        if case .verified(let transaction) = result,
           transaction.productID == Self.removeAdsID {
            adsRemoved = transaction.revocationDate == nil
            await transaction.finish()
        }
    }
}
