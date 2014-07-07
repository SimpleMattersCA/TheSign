//
//  Relevancy.m
//  TheSign
//
//  Created by Andrey Chudnovskiy on 2014-06-21.
//  Copyright (c) 2014 Andrey Chudnovskiy. All rights reserved.
//

#import "Relevancy.h"
#import "Featured.h"
#import "Statistics.h"
#import "User.h"
#import "Model.h"

@implementation Relevancy

@dynamic score;
@dynamic linkedOffer;
@dynamic linkedUser;

+(NSString*) entityName {return @"Relevancy";}

+(void)changeRelevancyForOffer:(Featured*)offer ByValue:(NSNumber*)value
{
    if(offer.linkedScore!=nil)
        offer.linkedScore.score=@(offer.linkedScore.score.doubleValue+value.doubleValue);
    else
    {
        Relevancy *newScore = [NSEntityDescription insertNewObjectForEntityForName:self.entityName
                                                      inManagedObjectContext:[Model sharedModel].managedObjectContext];
        newScore.linkedUser=[User currentUser];
        newScore.linkedOffer=offer;
        newScore.score=value;
    }
}



@end
