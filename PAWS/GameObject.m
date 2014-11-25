//
//  GameObject.m
//  PAWS
//
//  Created by Joseph Crotchett on 10/3/11.
//  Copyright (c) 2011 N/A. All rights reserved.
//

#import "GameObject.h"

@implementation GameObject

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

-(GameObject*) initWithDictionary:(NSDictionary*)dictionary
{
    self = [super init];
    if (self) 
    {
        [self setDropPosition:[dictionary objectForKey:@"Position"]];
        [self setPath:[dictionary objectForKey:@"Path"]];
        [self setTime:[dictionary objectForKey:@"Time"]];
        [self setType:[dictionary objectForKey:@"Type"]];
    }
    
    return self;
}

-(void)updateStateWithDeltaTime:(ccTime)deltaTime 
           andListOfPlayerUnits:(NSMutableArray*)listOfPlayerUnits
            andListOfEnemyUnits:(NSMutableArray*)listOfEnemyUnits {
    // This method need to be overrided.
}

-(CGRect)adjustedBoundingBox {
    CGRect unitBoundingBox = CGRectMake(
                                        self.position.x - self.contentSize.width/2.0f, 
                                        self.position.y - self.contentSize.height/2.0f- 10.0f, 
                                        self.contentSize.width, 
                                        self.contentSize.height-20.0f);
    return unitBoundingBox;
}

@synthesize dropPosition;
@synthesize path;
@synthesize time;
@synthesize type;
@synthesize gameObjectState;

@end
