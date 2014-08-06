//
//  InsightEngine.h
//  TheSign
//
//  Created by Andrey Chudnovskiy on 2014-05-06.
//  Copyright (c) 2014 Andrey Chudnovskiy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Model.h"

@class Featured;

/**
 Singleton for generator of welcoming messages.
 */
@interface InsightEngine : NSObject


+ (InsightEngine*) sharedInsight;


/**
 Generate welcoming text for the iBeacon case
 */
-(NSString*)generateWelcomeTextForBeaconWithMajor: (NSNumber*)major andMinor:(NSNumber*)minor ChosenOffer:(Featured**)chosenOffer;

/**
 Generate welcoming text for the GPS case
 */
-(NSString*)generateWelcomeTextForGPSdetectedMajor:(NSNumber*)major ChosenOffer:(Featured**)chosenOffer;


@end
