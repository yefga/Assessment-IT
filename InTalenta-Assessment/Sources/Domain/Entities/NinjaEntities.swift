//
//  NinjaEntities.swift
//  InTalenta-Assessment
//
//  Created by Yefga on 05/11/23.
//

import Foundation

// MARK: - NinjaModel
struct AnimalDataModel: Codable, Equatable {
    let name: String?
    let taxonomy: TaxonomyModel?
    let locations: [String]?
    let characteristics: CharacteristicsModel?
}

// MARK: - Characteristics
struct CharacteristicsModel: Codable, Equatable {
    let mainPrey, habitat, predators, diet: String?
    let averageLitterSize, lifestyle, favoriteFood, type: String?
    let slogan, color, skinType, topSpeed: String?
    let lifespan, weight, prey, nameOfYoung: String?
    let groupBehavior, estimatedPopulationSize, biggestThreat, mostDistinctiveFeature: String?
    let otherNameS, gestationPeriod, commonName, numberOfSpecies: String?
    let location, group, height, ageOfSexualMaturity: String?
    let ageOfWeaning, length: String?

    enum CodingKeys: String, CodingKey {
        case mainPrey = "main_prey"
        case habitat, predators, diet
        case averageLitterSize = "average_litter_size"
        case lifestyle
        case favoriteFood = "favorite_food"
        case type, slogan, color
        case skinType = "skin_type"
        case topSpeed = "top_speed"
        case lifespan, weight, prey
        case nameOfYoung = "name_of_young"
        case groupBehavior = "group_behavior"
        case estimatedPopulationSize = "estimated_population_size"
        case biggestThreat = "biggest_threat"
        case mostDistinctiveFeature = "most_distinctive_feature"
        case otherNameS = "other_name(s)"
        case gestationPeriod = "gestation_period"
        case commonName = "common_name"
        case numberOfSpecies = "number_of_species"
        case location, group, height
        case ageOfSexualMaturity = "age_of_sexual_maturity"
        case ageOfWeaning = "age_of_weaning"
        case length
    }
}

// MARK: - Taxonomy
struct TaxonomyModel: Codable, Equatable {
    let kingdom, phylum, taxonomyClass, order: String?
    let family, genus, scientificName: String?

    enum CodingKeys: String, CodingKey {
        case kingdom, phylum
        case taxonomyClass = "class"
        case order, family, genus
        case scientificName = "scientific_name"
    }
}

extension AnimalDataModel {
    static func mock() -> AnimalDataModel {
        return AnimalDataModel(
            name: "Sample Ninja",
            taxonomy: TaxonomyModel.mock(),
            locations: ["Location 1", "Location 2"],
            characteristics: CharacteristicsModel.mock()
        )
    }
}

extension CharacteristicsModel {
    static func mock() -> CharacteristicsModel {
        return CharacteristicsModel(
            mainPrey: "Prey",
            habitat: "Habitat",
            predators: "Predators",
            diet: "Diet",
            averageLitterSize: "3",
            lifestyle: "Lifestyle",
            favoriteFood: "Favorite Food",
            type: "Type",
            slogan: "Slogan",
            color: "Color",
            skinType: "Skin Type",
            topSpeed: "Top Speed",
            lifespan: "10 years",
            weight: "50 kg",
            prey: "Prey",
            nameOfYoung: "Young",
            groupBehavior: "Group Behavior",
            estimatedPopulationSize: "1000",
            biggestThreat: "Threat",
            mostDistinctiveFeature: "Feature",
            otherNameS: "Other Names",
            gestationPeriod: "3 months",
            commonName: "Common Name",
            numberOfSpecies: "5",
            location: "Location",
            group: "Group",
            height: "180 cm",
            ageOfSexualMaturity: "2 years",
            ageOfWeaning: "6 months",
            length: "Length"
        )
    }
}

extension TaxonomyModel {
    static func mock() -> TaxonomyModel {
        return TaxonomyModel(
            kingdom: "Animalia",
            phylum: "Chordata",
            taxonomyClass: "Mammalia",
            order: "Carnivora",
            family: "Felidae",
            genus: "Panthera",
            scientificName: "Panthera leo"
        )
    }
}



