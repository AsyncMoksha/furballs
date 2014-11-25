//
//  Catapult.h
//  PAWS
//
//  Created by Zinan Xing on 11/24/11.
//  Copyright (c) 2011 University of Southern California. All rights reserved.
//

#import "ItemClass.h"

@interface Catapult : ItemClass {
    CGPoint destination;
}

-(void) doCatapult;
-(void) applyEffectOnUnits:(NSMutableArray *)unitArray;

@property (nonatomic, assign) CGPoint destination;

@end
