//
//  ConceptObjectTitleViewController.h
//  ConceptMap
//
//  Created by Preston Rohner on 9/19/10.
//  Copyright 2010 Cool Tool Apps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Utility.h"

@class ConceptObject;

@interface ConceptObjectTitleViewController : UIViewController {
	UITextField *objectTitle;
	ConceptObject *conceptObject;
}

@property (nonatomic, retain) IBOutlet UITextField *objectTitle;
@property (nonatomic, retain) ConceptObject *conceptObject;

- (IBAction)titleTextHasChanged:(id)sender;

@end
