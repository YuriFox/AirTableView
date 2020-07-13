//
//  ConfigurableView.swift
//  AirTableView
//
//  Created by Lysytsia Yurii on 13.07.2020.
//  Copyright © 2020 Lysytsia Yurii. All rights reserved.
//

// MARK: - ConfigurableView
protocol ConfigurableView: IdentificableView {
    
    /// Configure view with some non specific model
    func configure(model: Any?)
    
}

// MARK: - ModelConfigurableView
protocol ModelConfigurableView: ConfigurableView {
    
    /// Configure view with some specific model type
    func configure(model: Model)
    
    associatedtype Model
    
}

extension ModelConfigurableView {
    
    func configure(model: Any?) {
        guard let configurableModel = model as? Model else {
            assertionFailure("Invalid model for configure view of type `\(type(of: self))`. Model is not confirm to model type \(Model.self)")
            return
        }
        self.configure(model: configurableModel)
    }
    
}
