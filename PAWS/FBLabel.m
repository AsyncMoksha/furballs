//
//  FBLabel.m
//  PAWS
//
//  Created by Zinan Xing on 11/26/11.
//  Copyright 2011 University of Southern California. All rights reserved.
//

#import "FBLabel.h"

@implementation FBLabel
@synthesize labelSprite = _labelSprite;
@synthesize info = _info;

-(id) initWithLabelFileName: (NSString*) filename andInfo: (NSString*) inInfo{
    
    self = [super init];
    if(self){
        _labelSprite = [CCSprite spriteWithFile:filename];
        if(_labelSprite){
            [self addChild: _labelSprite z:1];
            self.contentSize = _labelSprite.contentSize;
        }
        //_info = [CCLabelBMFont labelWithString:inInfo fntFile:@"AppleLiGothic_Black18.fnt"];
        _info = [CCLabelTTF labelWithString:inInfo fontName:@"Arial" fontSize:16.0];
        if(_info){
            _info.anchorPoint = ccp(0,0.5);
            _info.position = ccp(-80,0);
            [self addChild:_info z:2];
        }
    }
    return self;
}

-(void) dealloc{
    [_labelSprite release];
    [_info release];
    [super dealloc];
}
@end

