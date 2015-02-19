//
//  pauseButton.h
//  DCalling
//
//  Created by Ramesh on 21/07/14.
//
//

#import "UIToggleButton.h"
#include "linphone/linphonecore.h"

typedef enum _pauseButtonType {
    pauseButtonType_CurrentCall,
    pauseButtonType_Call,
    pauseButtonType_Conference
} pauseButtonType;

@interface pauseButton : UIToggleButton<UIToggleButtonDelegate>{
@private
    pauseButtonType type;
    LinphoneCall* call;
}

- (void)setType:(pauseButtonType) type call:(LinphoneCall*)call;

@end
