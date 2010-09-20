//
//  ConceptMapViewController.h
//  ConceptMap
//
//  Created by Preston Rohner on 9/8/10.
//  Copyright Cool Tool Apps 2010. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "ConceptMapView.h"
#import "DocumentsViewController.h"

@interface ConceptMapViewController : UIViewController <UIScrollViewDelegate> {
	UIToolbar *toolbar;
	UIBarButtonItem *documentsButton;
	DocumentsViewController *documentsViewController;
	ConceptMapView *conceptMapView;
}

@property (nonatomic, retain) IBOutlet UIToolbar *toolbar;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *documentsButton;

- (IBAction)documentButtonTapped:(id)sender;
- (IBAction)addConcept:(id)sender;

@end

