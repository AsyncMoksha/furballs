//
//  HelloWorldLayer.h
//  PAWS
//
//  Created by Pisit Praiwattana on 9/21/54 BE.
//  Copyright __MyCompanyName__ 2554. All rights reserved.
//
//  I save this class to debug when there is something wrong with loading scene.
//  We can experiment anything and add it to be load, so just keep it for time-being.
//


// When you import this file, you import all the cocos2d classes
#import "cocos2d.h"

// HelloWorldLayer
@interface HelloWorldLayer : CCLayer
{
    CCLabelTTF *_label;
}

// returns a CCScene that contains the HelloWorldLayer as the only child
+(CCScene *) scene;

@end
