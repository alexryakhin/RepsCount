//
//  ForearmsExerciseModel.swift
//  RepsCount
//
//  Created by Aleksandr Riakhin on 3/16/25.
//


public enum ForearmsExerciseModel: String, CaseIterable, ExerciseModel {
    
    case deadHang = "Dead Hang"
    case wristCurls = "Wrist Curls"
    case reverseWristCurls = "Reverse Wrist Curls"
    case resistanceBandWristCurls = "Resistance Band Wrist Curls"
    case resistanceBandReverseWristCurls = "Resistance Band Reverse Wrist Curls"
    case farmerWalk = "Farmer's Walk"
    case pinchGripHold = "Pinch Grip Hold"

    public var id: String { rawValue }

    public var category: ExerciseCategory {
        return .forearms
    }

    public var type: ExerciseType {
        return .strengthTraining
    }

    public var equipment: ExerciseEquipment {
        switch self {
        case .deadHang:
            return .bars
        case .wristCurls, .reverseWristCurls, .farmerWalk, .pinchGripHold:
            return .gym
        case .resistanceBandWristCurls, .resistanceBandReverseWristCurls:
            return .resistanceBands
        }
    }

    public var metricType: ExerciseMetricType {
        return .weightAndReps
    }

    public var primaryMuscleGroups: [MuscleGroup] {
        switch self {
        case .deadHang, .farmerWalk, .pinchGripHold:
            return [.brachioradialis]
        case .wristCurls, .resistanceBandWristCurls:
            return [.flexorCarpiRadialis]
        case .reverseWristCurls, .resistanceBandReverseWristCurls:
            return [.extensorCarpiRadialis]
        }
    }

    public var secondaryMuscleGroups: [MuscleGroup] {
        switch self {
        case .deadHang:
            return [.latissimusDorsi]
        case .wristCurls, .reverseWristCurls, .resistanceBandWristCurls, .resistanceBandReverseWristCurls:
            return [.brachialis]
        case .farmerWalk, .pinchGripHold:
            return [.trapezius]
        }
    }
}
