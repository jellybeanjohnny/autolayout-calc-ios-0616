//
//  FISViewController.m
//  Open-Me
//
//  Created by Joe Burgess on 3/4/14.
//  Copyright (c) 2014 Joe Burgess. All rights reserved.
//

#import "FISViewController.h"



@interface FISViewController ()

typedef enum {
	FISDisplayFirstOperand,
	FISDisplaySecondOperand,
	FISDisplayResult
} CurrentDisplay;

@property (weak, nonatomic) IBOutlet UILabel *displayLabel;

@property (strong, nonatomic) NSMutableString *firstOperand;
@property (strong, nonatomic) NSMutableString *secondOperand;
@property (nonatomic) CurrentDisplay currentDisplay;
@property (strong, nonatomic) NSString *operation;
@property (strong, nonatomic) NSString *result;

@property (nonatomic) BOOL hasDecimal;

@end


@implementation FISViewController

- (NSMutableString *)firstOperand
{
	if (!_firstOperand) {
		_firstOperand = [[NSMutableString alloc] initWithString:@""];
	}
	return _firstOperand;
}

- (NSMutableString *)secondOperand
{
	if (!_secondOperand) {
		_secondOperand = [[NSMutableString alloc] initWithString:@""];
	}
	return _secondOperand;
}

- (void)viewDidLoad
{
	self.currentDisplay = FISDisplayFirstOperand;
	[super viewDidLoad];
}

- (IBAction)numberSelected:(UIButton *)selectedButton
{
	if (self.hasDecimal && [selectedButton.titleLabel.text isEqualToString:@"."]) {
		return;
	}
	
	if (self.currentDisplay == FISDisplayFirstOperand) {
		// Append the first operand
		[self.firstOperand appendString:selectedButton.titleLabel.text];
		[self _updateUI];
	}
	else if (self.currentDisplay == FISDisplaySecondOperand) {
		// append to second operand
		[self.secondOperand appendString:selectedButton.titleLabel.text];
		[self _updateUI];
	}
}

- (IBAction)operationSelected:(UIButton *)selectedButton
{
	self.operation = selectedButton.titleLabel.text;
	
	self.currentDisplay = FISDisplaySecondOperand;
	
}

- (IBAction)calculateResults:(id)sender
{
	if ([self.secondOperand isEqualToString:@""]) {
		NSLog(@"No second operand, nothing to calculate");
		return;
	}
	
	self.currentDisplay = FISDisplayResult;
	
	CGFloat firstOperand = [self.firstOperand floatValue];
	CGFloat secondOperand = [self.secondOperand floatValue];
	CGFloat result = 0;
	
	// Apply the operation
	if ([self.operation isEqualToString:@"+"]) {
		result = firstOperand + secondOperand;
	}
	else if ([self.operation isEqualToString:@"-"]) {
		result = firstOperand - secondOperand;
	}
	else if ([self.operation isEqualToString:@"/"]) {
		result = firstOperand / secondOperand;
	}
	else if ([self.operation isEqualToString:@"x"]) {
		result = firstOperand * secondOperand;
	}
	
	self.result = [NSString stringWithFormat:@"%f", result];
	[self _updateUI];
	[self _clearOperands];
}


- (void)_updateUI
{
	if (self.currentDisplay == FISDisplayFirstOperand) {
		// set the display label to the first operand value
		self.displayLabel.text = self.firstOperand;
	}
	else if (self.currentDisplay == FISDisplaySecondOperand) {
		// set the display to the second operand value
		self.displayLabel.text = self.secondOperand;
	}
	else {
		// set the display to the result value
		self.displayLabel.text = [self _formatResult:self.result];
	}
}

- (void)_clearOperands
{
	// first operand gets the result value
	self.firstOperand = [[NSMutableString alloc] initWithString:self.result];
	
	// second operand is cleared
	self.secondOperand = [@"" mutableCopy];
	
	// Current Display set to second operand
	self.currentDisplay = FISDisplaySecondOperand;
}

- (NSString *)_formatResult:(NSString *)result
{
	// Result maybe have a bunch of 0s at the end. Scan the string from right to left
	// until you find a number (1 - 9) or the decimal and then remove everything
	// to the right of that number
	NSString *formattedString = @"";
	
	for (NSInteger i = result.length - 1; i >= 0; i--) {
		NSString *substring = [result substringWithRange:NSMakeRange(i, 1)];
		
		if ([substring isEqualToString:@"."]) {
			// Remove everything to the right, INCLUDING this index
			formattedString = [result substringToIndex:i];
			break;
		}
		
		if (![substring isEqualToString:@"0"]) {
			// Remove everything to the right, EXCLUDING this index
			formattedString = [result substringToIndex:i + 1];
			break;
		}
	}
	return formattedString;
}


@end
