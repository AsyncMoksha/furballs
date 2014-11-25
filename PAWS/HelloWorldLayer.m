//
//  HelloWorldLayer.m
//  PAWS
//
//  Created by Pisit Praiwattana on 9/21/54 BE.
//  Copyright __MyCompanyName__ 2554. All rights reserved.
//


// Import the interfaces
#import "HelloWorldLayer.h"

// HelloWorldLayer implementation
@implementation HelloWorldLayer

+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	HelloWorldLayer *layer = [HelloWorldLayer node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

// on "init" you need to initialize your instance
-(id) init
{
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super" return value
	if( (self=[super init])) {

		// ask director the the window size
		CGSize winSize = [[CCDirector sharedDirector] winSize];
	
		// Create a label for display purposes
        _label = [[CCLabelTTF labelWithString:@"Last button: None" 
                                   dimensions:CGSizeMake(320, 50) alignment:UITextAlignmentCenter 
                                     fontName:@"Arial" fontSize:32.0] retain];
        _label.position = ccp(winSize.width/2, 
                              winSize.height-(_label.contentSize.height/2));
        [self addChild:_label];
	}
	return self;
}

- (void) startButtonTapped : (id)sender{
    [_label setString:@"Last button!"];
}

// on "dealloc" you need to release all your retained objects
- (void) dealloc
{
	// in case you have something to dealloc, do it in this method
	// in this particular example nothing needs to be released.
	// cocos2d will automatically release all the children (Label)
    
	// don't forget to call "super dealloc"
	[super dealloc];
}
@end
