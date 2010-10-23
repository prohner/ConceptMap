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
	UIBarButtonItem *documentTitleHolder;
	UITextField *documentTitle;
	ConceptMapView *conceptMapView;
	UIPopoverController *popover;
	id conceptMapViewDelegateHold;
	UIBarButtonItem *propertyInspectorButton;
}

@property (nonatomic, retain) IBOutlet UIToolbar *toolbar;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *documentsButton;
@property (nonatomic, retain) IBOutlet UITextField *documentTitle;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *documentTitleHolder;
@property (nonatomic, retain) IBOutlet UIPopoverController *popover;
@property (nonatomic, retain) IBOutlet ConceptMapView *conceptMapView;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *propertyInspectorButton;

- (IBAction)documentButtonTapped:(id)sender;
- (IBAction)addButtonTapped:(id)sender;
- (void)addConcept:(id)sender;
- (IBAction)documentTitleChanged:(id)sender;
- (IBAction)actionButtonTapped:(id)sender;
- (IBAction)settingsButtonTapped:(id)sender;
- (IBAction)sliderStarted:(id)sender;
- (IBAction)sliderChanged:(id)sender;
- (IBAction)sliderStopped:(id)sender;

- (void)resetConceptMapView;
- (UIPopoverController *)popoverControllerFor:(UIViewController *)vc;
@end

