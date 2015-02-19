//
//  pauseButton.m
//  DCalling
//
//  Created by Ramesh on 21/07/14.
//
//

#import "pauseButton.h"
#import "LinphoneManager.h"

@implementation pauseButton

#pragma mark - Lifecycle Functions

- (void)initUIPauseButton {
    type = pauseButtonType_CurrentCall;
}

- (id)init{
    self = [super init];
    if (self) {
		[self initUIPauseButton];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)decoder {
    self = [super initWithCoder:decoder];
    if (self) {
		[self initUIPauseButton];
	}
    return self;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
		[self initUIPauseButton];
    }
    return self;
}


#pragma mark - Static Functions

+ (bool)isInConference: (LinphoneCall*) call {
    if (!call)
        return false;
    return linphone_call_is_in_conference(call);
}

+ (int)notInConferenceCallCount: (LinphoneCore*) lc {
    int count = 0;
    const MSList* calls = linphone_core_get_calls(lc);
    
    while (calls != 0) {
        if (![pauseButton isInConference: (LinphoneCall*)calls->data]) {
            count++;
        }
        calls = calls->next;
    }
    return count;
}

+ (LinphoneCall*)getCall {
    LinphoneCore* lc = [LinphoneManager getLc];
    LinphoneCall* currentCall = linphone_core_get_current_call(lc);
	if (currentCall == nil && linphone_core_get_calls_nb(lc) == 1) {
        currentCall = (LinphoneCall*) linphone_core_get_calls(lc)->data;
    }
    return currentCall;
}


#pragma mark -

- (void)setType:(pauseButtonType) atype call:(LinphoneCall*)acall {
    type = atype;
    call = acall;
}


#pragma mark - UIToggleButtonDelegate Functions

- (void)onOn {
    if(![LinphoneManager isLcReady]) {
        [LinphoneLogger logc:LinphoneLoggerWarning format:"Cannot toggle pause button: Linphone core not ready"];
        return;
    }
    switch (type) {
        case pauseButtonType_Call:
        {
            if (call != nil) {
                linphone_core_pause_call([LinphoneManager getLc], call);
            } else {
                [LinphoneLogger logc:LinphoneLoggerWarning format:"Cannot toggle pause buttton, because no current call"];
            }
            break;
        }
        case pauseButtonType_Conference:
        {
            linphone_core_leave_conference([LinphoneManager getLc]);
            
            // Fake event
            [[NSNotificationCenter defaultCenter] postNotificationName:kLinphoneCallUpdate object:self];
            break;
        }
        case pauseButtonType_CurrentCall:
        {
            LinphoneCall* currentCall = [pauseButton getCall];
            if (currentCall != nil) {
                linphone_core_pause_call([LinphoneManager getLc], currentCall);
            } else {
                [LinphoneLogger logc:LinphoneLoggerWarning format:"Cannot toggle pause buttton, because no current call"];
            }
            break;
        }
    }
}

- (void)onOff {
    if(![LinphoneManager isLcReady]) {
        [LinphoneLogger logc:LinphoneLoggerWarning format:"Cannot toggle pause button: Linphone core not ready"];
        return;
    }
    switch (type) {
        case pauseButtonType_Call:
        {
            if (call != nil) {
                linphone_core_resume_call([LinphoneManager getLc], call);
            } else {
                [LinphoneLogger logc:LinphoneLoggerWarning format:"Cannot toggle pause buttton, because no current call"];
            }
            break;
        }
        case pauseButtonType_Conference:
        {
            linphone_core_enter_conference([LinphoneManager getLc]);
            // Fake event
            [[NSNotificationCenter defaultCenter] postNotificationName:kLinphoneCallUpdate object:self];
            break;
        }
        case pauseButtonType_CurrentCall:
        {
            LinphoneCall* currentCall = [pauseButton getCall];
            if (currentCall != nil) {
                linphone_core_resume_call([LinphoneManager getLc], currentCall);
            } else {
                [LinphoneLogger logc:LinphoneLoggerWarning format:"Cannot toggle pause buttton, because no current call"];
            }
            break;
        }
    }
}

- (bool)onUpdate {
    bool ret = false;
    // TODO: disable pause on not running call
    if([LinphoneManager isLcReady]) {
        LinphoneCore *lc = [LinphoneManager getLc];
        switch (type) {
            case pauseButtonType_Call:
            {
                if (call != nil) {
                    LinphoneCallState state = linphone_call_get_state(call);
                    if(state == LinphoneCallPaused || state == LinphoneCallPausing) {
                        ret = true;
                    }
                    [self setEnabled:TRUE];
                } else {
                    [self setEnabled:FALSE];
                }
                break;
            }
            case pauseButtonType_Conference:
            {
                if(linphone_core_get_conference_size(lc) > 0) {
                    if (!linphone_core_is_in_conference(lc)) {
                        ret = true;
                    }
                    [self setEnabled:TRUE];
                } else {
                    [self setEnabled:FALSE];
                }
                break;
            }
            case pauseButtonType_CurrentCall:
            {
                LinphoneCall* currentCall = [pauseButton getCall];
                if (currentCall != nil) {
                    LinphoneCallState state = linphone_call_get_state(currentCall);
                    if(state == LinphoneCallPaused || state == LinphoneCallPausing) {
                        ret = true;
                    }
                    [self setEnabled:TRUE];
                } else {
                    [self setEnabled:FALSE];
                }
                break;
            }
        }
    } else {
        [LinphoneLogger logc:LinphoneLoggerWarning format:"Cannot update pause button: Linphone core not ready"];
    }
    return ret;
}

@end

