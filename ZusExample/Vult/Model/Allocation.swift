//
//  Allocation.swift
//  ZusExample
//
//  Created by Aaryan Kothari on 02/01/23.
//

import Foundation

typealias Allocations = [Allocation]

public struct Allocation: Codable, Equatable {
    var id, tx: String
    var dataShards, parityShards, size, expirationDate: Int
    var ownerID, ownerPublicKey, payerID: String
    var blobbers: [Blobber]
    var stats: Stats
    var timeUnit, writePool: Int?
    var blobberDetails: [BlobberDetail]
    var readPriceRange, writePriceRange: PriceRange?
    var challengeCompletionTime, startTime, movedToChallenge, movedToValidators: Int?
    var fileOptions: Int?
    var thirdPartyExtendable: Bool?
    
    enum CodingKeys: String, CodingKey {
        case id, tx
        case dataShards = "data_shards"
        case parityShards = "parity_shards"
        case size
        case expirationDate = "expiration_date"
        case ownerID = "owner_id"
        case ownerPublicKey = "owner_public_key"
        case payerID = "payer_id"
        case blobbers, stats
        case timeUnit = "time_unit"
        case writePool = "write_pool"
        case blobberDetails = "blobber_details"
        case readPriceRange = "read_price_range"
        case writePriceRange = "write_price_range"
        case challengeCompletionTime = "challenge_completion_time"
        case startTime = "start_time"
        case movedToChallenge = "moved_to_challenge"
        case movedToValidators = "moved_to_validators"
        case fileOptions = "file_options"
        case thirdPartyExtendable = "third_party_extendable"
    }
    
    public init(id: String, tx: String, dataShards: Int, parityShards: Int, size: Int, expirationDate: Int, ownerID: String, ownerPublicKey: String, payerID: String, blobbers: [Blobber], stats: Stats, timeUnit: Int, writePool: Int, blobberDetails: [BlobberDetail], readPriceRange: PriceRange, writePriceRange: PriceRange, challengeCompletionTime: Int, startTime: Int, movedToChallenge: Int, movedToValidators: Int, fileOptions: Int, thirdPartyExtendable: Bool) {
        self.id = id
        self.tx = tx
        self.dataShards = dataShards
        self.parityShards = parityShards
        self.size = size
        self.expirationDate = expirationDate
        self.ownerID = ownerID
        self.ownerPublicKey = ownerPublicKey
        self.payerID = payerID
        self.blobbers = blobbers
        self.stats = stats
        self.timeUnit = timeUnit
        self.writePool = writePool
        self.blobberDetails = blobberDetails
        self.readPriceRange = readPriceRange
        self.writePriceRange = writePriceRange
        self.challengeCompletionTime = challengeCompletionTime
        self.startTime = startTime
        self.movedToChallenge = movedToChallenge
        self.movedToValidators = movedToValidators
        self.fileOptions = fileOptions
        self.thirdPartyExtendable = thirdPartyExtendable
    }
    
    mutating func addSize(_ size: Int) {
        self.stats.usedSize = (self.stats.usedSize ?? 0) + size
    }
    
    var allocationFraction: Double {
        return Double(stats.usedSize ?? 0)/Double(size ?? 1)
    }
    
    var allocationPercentage: Int {
        let divisor = size == 0 ? 1 : size
        return ((stats.usedSize ?? 0)/(divisor)) * 100
    }
    
    var defaultName: String {
        return "Allocation"
    }
    
    public static func == (lhs: Allocation, rhs: Allocation) -> Bool {
        return lhs.id == rhs.id
    }
    
    static let `default` = Allocation(id: "28628268", tx: "3973879", dataShards: 2, parityShards: 2, size: 10293937, expirationDate: 3973893793, ownerID: "37637863876383", ownerPublicKey: "38368376783638", payerID: "45634563456", blobbers: [], stats: Stats(usedSize: 345678, numOfWrites: 120, numOfReads: 450, totalChallenges: 80, numOpenChallenges: 10, numSuccessChallenges: 60, numFailedChallenges: 10, latestClosedChallenge: "2023-04-25 12:30:00"), timeUnit: 3600, writePool: 100000, blobberDetails: [], readPriceRange: PriceRange(min: 1, max: 10), writePriceRange: PriceRange(min: 10, max: 100), challengeCompletionTime: 1800, startTime: 1620000000, movedToChallenge: 0, movedToValidators: 0, fileOptions: 0, thirdPartyExtendable: false)
}

// MARK: - BlobberDetail
public struct BlobberDetail: Codable {
    var blobberID: String
    var size: Int
    var terms: Terms
    var minLockDemand, spent, penalty, readReward: Int
    var returned, challengeReward, finalReward: Int
    
    enum CodingKeys: String, CodingKey {
        case blobberID = "blobber_id"
        case size, terms
        case minLockDemand = "min_lock_demand"
        case spent, penalty
        case readReward = "read_reward"
        case returned
        case challengeReward = "challenge_reward"
        case finalReward = "final_reward"
    }
    
    public init(blobberID: String, size: Int, terms: Terms, minLockDemand: Int, spent: Int, penalty: Int, readReward: Int, returned: Int, challengeReward: Int, finalReward: Int) {
        self.blobberID = blobberID
        self.size = size
        self.terms = terms
        self.minLockDemand = minLockDemand
        self.spent = spent
        self.penalty = penalty
        self.readReward = readReward
        self.returned = returned
        self.challengeReward = challengeReward
        self.finalReward = finalReward
    }
}

// MARK: - Terms
public struct Terms: Codable {
    
    
    var readPrice, writePrice: Int
    var minLockDemand: Double
    var maxOfferDuration: Int
    
    enum CodingKeys: String, CodingKey {
        case readPrice = "read_price"
        case writePrice = "write_price"
        case minLockDemand = "min_lock_demand"
        case maxOfferDuration = "max_offer_duration"
    }
    
    public init(readPrice: Int, writePrice: Int, minLockDemand: Double, maxOfferDuration: Int) {
        self.readPrice = readPrice
        self.writePrice = writePrice
        self.minLockDemand = minLockDemand
        self.maxOfferDuration = maxOfferDuration
    }
}

// MARK: - Blobber
public struct Blobber: Codable {
    
    
    var id: String
    var url: String
    
    public init(id: String, url: String) {
        self.id = id
        self.url = url
    }
}

// MARK: - PriceRange
public struct PriceRange: Codable {
    public init(min: Int, max: Int) {
        self.min = min
        self.max = max
    }
    
    var min, max: Int
}

// MARK: - Stats
public struct Stats: Codable {
    public init(usedSize: Int, numOfWrites: Int, numOfReads: Int, totalChallenges: Int, numOpenChallenges: Int, numSuccessChallenges: Int, numFailedChallenges: Int, latestClosedChallenge: String) {
        self.usedSize = usedSize
        self.numOfWrites = numOfWrites
        self.numOfReads = numOfReads
        self.totalChallenges = totalChallenges
        self.numOpenChallenges = numOpenChallenges
        self.numSuccessChallenges = numSuccessChallenges
        self.numFailedChallenges = numFailedChallenges
        self.latestClosedChallenge = latestClosedChallenge
    }
    
    var usedSize, numOfWrites, numOfReads, totalChallenges: Int
    var numOpenChallenges, numSuccessChallenges, numFailedChallenges: Int
    var latestClosedChallenge: String
    
    enum CodingKeys: String, CodingKey {
        case usedSize = "used_size"
        case numOfWrites = "num_of_writes"
        case numOfReads = "num_of_reads"
        case totalChallenges = "total_challenges"
        case numOpenChallenges = "num_open_challenges"
        case numSuccessChallenges = "num_success_challenges"
        case numFailedChallenges = "num_failed_challenges"
        case latestClosedChallenge = "latest_closed_challenge"
    }
}
