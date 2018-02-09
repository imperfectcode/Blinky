//
//  BlinkyView.h
//  Blinky
//
//  Created by David on 8/2/18.
//  Copyright © 2018 Imperfect Code. All rights reserved.
//
//  Based on the tutorial "Write a Screen Saver: Part I" by Brian Christensen
//  http://cocoadevcentral.com/articles/000088.php
//


#import <ScreenSaver/ScreenSaver.h>

@interface BlinkyView : ScreenSaverView
{
    IBOutlet id configSheet;
    IBOutlet id drawFilledShapesOption;
    IBOutlet id drawOutlinedShapesOption;
    IBOutlet id drawBothOption;
}

@end
