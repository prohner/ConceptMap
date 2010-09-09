//
//  ConceptMapAppDelegate.h
//  ConceptMap
//
//  Created by Preston Rohner on 9/8/10.
//  Copyright Cool Tool Apps 2010. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ConceptMapViewController;

@interface ConceptMapAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    ConceptMapViewController *viewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet ConceptMapViewController *viewController;

@end

