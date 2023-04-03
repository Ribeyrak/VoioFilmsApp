//
//  Style.swift
//  VoioFilmsApp
//
//  Created by Evhen Lukhtan on 30.03.2023.
//

import UIKit
import Nuke

enum Style {
    enum Offset {
        static let standard: CGFloat = 16
    }

    enum Animation {
        static let defaultDuration = 0.25
    }

    enum NukeOptions {
        static let loadingOptions = ImageLoadingOptions(
            placeholder: UIImage(named: "loading_img"),
            transition: .fadeIn(duration: 0.33),
            failureImage: UIImage(named: "big_no_img")
        )

        static let newOptions = makeOptions(contentMode: .scaleAspectFill)
        static let aspectFitOptions = makeOptions(contentMode: .scaleAspectFit)

        private static func makeOptions(contentMode: UIImageView.ContentMode = .scaleAspectFill) -> ImageLoadingOptions {
            let config = UIImage.SymbolConfiguration(font: .preferredFont(forTextStyle: .title1))
            let image = UIImage(systemName: "photo")?
                .applyingSymbolConfiguration(config)?
                .withTintColor(.systemGray3, renderingMode: .alwaysOriginal)
            var imageOptions = ImageLoadingOptions(placeholder: image, transition: .fadeIn(duration: 0.25),
                                                   failureImage: image)
            imageOptions.contentModes = .init(success: contentMode, failure: .center, placeholder: .center)
            return imageOptions
        }
    }
}
