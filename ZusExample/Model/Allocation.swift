//
//  Allocation.swift
//  ZusExample
//
//  Created by Aaryan Kothari on 02/01/23.
//

import Foundation

typealias Allocations = [Allocation]

struct Allocation: Codable {
  var id,name: String?
  var dataShards, parityShards, expirationDate: Int?
  var size, usedSize, numOfWrites, numOfReads, totalChallenges: Int?
  var numOpenChallenges, numSuccessChallenges, numFailedChallenges: Int?
  var latestClosedChallenge: String?

  enum CodingKeys: String, CodingKey {
      case id
      case name
      case dataShards = "data_shards"
      case parityShards = "parity_shards"
      case size
      case expirationDate = "expiration_date"
      case usedSize = "used_size"
      case numOfWrites = "num_of_writes"
      case numOfReads = "num_of_reads"
      case totalChallenges = "total_challenges"
      case numOpenChallenges = "num_open_challenges"
      case numSuccessChallenges = "num_success_challenges"
      case numFailedChallenges = "num_failed_challenges"
      case latestClosedChallenge = "latest_closed_challenge"
  }
  
  mutating func addStats(_ model: Self) {
    self.usedSize = model.usedSize
    self.numOfWrites = model.numOfWrites
    self.numOfReads = model.numOfReads
    self.totalChallenges = model.totalChallenges
    self.numOpenChallenges = model.numOpenChallenges
    self.numSuccessChallenges = model.numSuccessChallenges
    self.numFailedChallenges = model.numFailedChallenges
    self.latestClosedChallenge = model.latestClosedChallenge
  }
   
    var allocationFraction: Double {
        return Double(usedSize ?? 0)/Double(size ?? 1)
    }
}
