//
//  InCallViewController.h
//  FRBooster
//
//  Created by Ramesh on 29/05/14.
//
//

#import <UIKit/UIKit.h>

#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>

#import "UIMicroButton.h"
#import "UIPauseButton.h"
#import "UISpeakerButton.h"
#import "UIVideoButton.h"
#import "UIHangUpButton.h"
#import "UIDigitButton.h"
#import "TPMultiLayoutViewController.h"
#import "UIToggleButton.h"
#import "VideoZoomHandler.h"

@interface UICallCellData : NSObject {
@public
    bool minimize;
    //UICallCellOtherView view;
    LinphoneCall *call;
}
- (id)init:(LinphoneCall*) call minimized:(BOOL)minimized;

@property (nonatomic, retain) UIImage *image;
@property (nonatomic, retain) NSString *address;
@end

@interface InCallViewController : UIViewController<UIGestureRecognizerDelegate, ABPeoplePickerNavigationControllerDelegate>{
@private
    UITapGestureRecognizer* singleFingerTap;
    NSTimer* hideControlsTimer;
    NSTimer *dutaionTime;
    BOOL videoShown;
    VideoZoomHandler* videoZoomHandler;
    BOOL minimized;
}
@property (nonatomic, retain) UICallCellData *data;
@property (nonatomic, retain) IBOutlet UIPauseButton*   pauseButton;
@property (nonatomic, retain) IBOutlet UIButton*        conferenceButton;
@property (nonatomic, retain) IBOutlet UILabel*        nameAddress;
@property (nonatomic, retain) IBOutlet UILabel*        durationTimer;
@property (nonatomic, retain) IBOutlet UIButton*   videoButton;
@property (nonatomic, retain) IBOutlet UIButton*   microButton;
@property (nonatomic, retain) IBOutlet UIButton* speakerButton;
@property (nonatomic, retain) IBOutlet UIButton*  routesButton;
@property (nonatomic, retain) IBOutlet UIButton*  optionsButton;
@property (nonatomic, retain) IBOutlet UIButton*  hangupButton;
@property (nonatomic, retain) IBOutlet UIView*          padView;
@property (nonatomic, retain) IBOutlet UIView*          routesView;
@property (nonatomic, retain) IBOutlet UIView*          optionsView;
@property (nonatomic, retain) IBOutlet UIButton*        routesReceiverButton;
@property (nonatomic, retain) IBOutlet UIButton*        routesSpeakerButton;
@property (nonatomic, retain) IBOutlet UIButton*        routesBluetoothButton;
@property (nonatomic, retain) IBOutlet UIButton*        optionsAddButton;
@property (nonatomic, retain) IBOutlet UIButton*        optionsTransferButton;
@property (nonatomic, retain) IBOutlet UIButton*  dialerButton;

@property (nonatomic, retain) IBOutlet UIButton* oneButton;
@property (nonatomic, retain) IBOutlet UIButton* twoButton;
@property (nonatomic, retain) IBOutlet UIButton* threeButton;
@property (nonatomic, retain) IBOutlet UIButton* fourButton;
@property (nonatomic, retain) IBOutlet UIButton* fiveButton;
@property (nonatomic, retain) IBOutlet UIButton* sixButton;
@property (nonatomic, retain) IBOutlet UIButton* sevenButton;
@property (nonatomic, retain) IBOutlet UIButton* eightButton;
@property (nonatomic, retain) IBOutlet UIButton* nineButton;
@property (nonatomic, retain) IBOutlet UIButton* starButton;
@property (nonatomic, retain) IBOutlet UIButton* zeroButton;
@property (nonatomic, retain) IBOutlet UIButton* sharpButton;
@property (atomic)  BOOL speakerEnable;
@property (atomic)  BOOL muteEnable;
@property (nonatomic, retain) IBOutlet UILabel* topRightUpper;
@property (nonatomic, retain) IBOutlet UILabel* topRightBottom;
@property (assign) BOOL conferenceCell;
@property (nonatomic, assign) BOOL currentCall;
@property (nonatomic, retain) IBOutlet UILabel* videoCodecLabel;
@property (nonatomic, retain) IBOutlet UILabel* audioCodecLabel;
@property (nonatomic, retain) IBOutlet UIView* avatarView;
@property (nonatomic, retain) IBOutlet UIView* audioStatsView;
@property (nonatomic, retain) IBOutlet UIView* videoStatsView;
@property (nonatomic, retain) IBOutlet UIImageView *buttons;
@property (nonatomic, retain) IBOutlet UILabel *endlbl;
@property (nonatomic, retain) IBOutlet UIButton *contactButton;
@property(nonatomic, retain) IBOutlet UIButton* mergerButton;
@property (retain, nonatomic) IBOutlet UIView *flipView;
@property (retain, nonatomic) IBOutlet UITextField *dialTextView;
@property (retain, nonatomic) IBOutlet UIButton *smallEndButton;
@property (retain, nonatomic) IBOutlet UIButton *hideButton;
@property (retain, nonatomic) IBOutlet UIImageView *infoImageView;

- (IBAction)onRoutesClick:(id)sender;
- (IBAction)onRoutesBluetoothClick:(id)sender;
- (IBAction)onRoutesReceiverClick:(id)sender;
- (IBAction)onRoutesSpeakerClick:(id)sender;
- (IBAction)onOptionsClick:(id)sender;
- (IBAction)onOptionsTransferClick:(id)sender;
- (IBAction)onOptionsAddClick:(id)sender;
- (IBAction)onConferenceClick:(id)sender;
- (IBAction)onPadClick:(id)sender;
- (IBAction)onHangTouch:(id)sender;
- (IBAction)onAddTouch:(id)sender;
- (IBAction)onSpeakerTouch:(id)sender;
- (IBAction)onVideoTouch:(id)sender;
- (IBAction)onDialTouch:(id)sender;
-(IBAction)onMuteTouch:(id)sender;
- (IBAction)callContact;

// for Dialpad function
- (IBAction)addOne:(id)sender;
- (IBAction)addTwo:(id)sender;
- (IBAction)addThree:(id)sender;
- (IBAction)addFour:(id)sender;
- (IBAction)addFive:(id)sender;
- (IBAction)addSix:(id)sender;
- (IBAction)addSeven:(id)sender;
- (IBAction)addEight:(id)sender;
- (IBAction)addNine:(id)sender;
- (IBAction)addZero:(id)sender;
- (IBAction)addAstrik:(id)sender;
- (IBAction)addHash:(id)sender;


@end
