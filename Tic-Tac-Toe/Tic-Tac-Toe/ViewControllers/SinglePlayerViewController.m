//
//  SinglePlayerViewController.m
//  Tic-Tac-Toe
//
//  Created by Ognyanka Boneva on 18.07.18.
//  Copyright © 2018 Ognyanka Boneva. All rights reserved.
//

#import "SinglePlayerViewController.h"
#import "GameViewController.h"

#import "HumanModel.h"
#import "BotModel.h"

#import "GameEngine.h"

#import "Utilities.h"
#import "Constants.h"

#define PICKER_VIEW_COMPONENTS 1
#define EASY_LEVEL             @"Easy"
#define MEDIUM_LEVEL           @"Meduim"
#define HARD_LEVEL             @"Hard"
#define DEFAULT_NAME           @"Player1"

@interface SinglePlayerViewController () <UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *playerName;
@property (weak, nonatomic) IBOutlet UIPickerView *difficultyPicker;
@property (strong, nonatomic) NSArray *difficultyLevels;
@property (assign) EnumDifficulty difficulty;
@property (assign) EnumGame gameType;

@end

@implementation SinglePlayerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.difficultyLevels = @[EASY_LEVEL, MEDIUM_LEVEL, HARD_LEVEL];
    
    self.difficultyPicker.dataSource = self;
    self.difficultyPicker.delegate = self;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap];
    self.playerName.delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

-(void)dismissKeyboard {
    [self.view endEditing:YES];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return PICKER_VIEW_COMPONENTS;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return self.difficultyLevels.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return self.difficultyLevels[row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    self.difficulty = EnumDifficultyMedium;
    if ([self.difficultyLevels[row] isEqualToString:EASY_LEVEL]) {
        self.difficulty = EnumDifficultyEasy;
    }
    else if ([self.difficultyLevels[row] isEqualToString:HARD_LEVEL]) {
        self.difficulty = EnumDifficultyHard;
    }
}

- (IBAction)onPlayTap:(id)sender {
    GameViewController *gameController = (GameViewController *)[Utilities viewControllerWithClass:GameViewController.class];
    
    NSString *playerName = self.playerName.text;
    if ([playerName isEqualToString:@""]) {
        playerName = DEFAULT_NAME;
    }
    
    HumanModel *player1 = [[HumanModel alloc] initWithName:playerName];
    BotModel *player2 = [Utilities botWithDifficulty:self.difficulty];

    GameEngine *engine = [Utilities gameEngineFromType:self.gameType];
    engine.player1 = player1;
    engine.player2 = player2;

    [gameController setEngine:engine];
    gameController.gameMode = EnumGameModeOneDevice;
    gameController.gameType = self.gameType;
    [self.navigationController pushViewController:gameController animated:YES];
}

@end
