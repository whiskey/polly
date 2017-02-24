//
//  AWSManager.swift
//  Polly
//
//  Created by Carsten Witzke on 24/02/2017.
//  Copyright © 2017 Carsten Knoblich. All rights reserved.
//

import AWSCore

class AWSManager {
    
    class func setupAWSStack() {
        let region = AWSRegionType.EUWest1
        
        let credentialsProvider = AWSCognitoCredentialsProvider(regionType: region, identityPoolId: Config.poolId)
        
        let configuration = AWSServiceConfiguration(region: region, credentialsProvider: credentialsProvider)
        AWSServiceManager.default().defaultServiceConfiguration = configuration
        
        AWSLogger.default().logLevel = AWSLogLevel.warn
    }
}
