#!/usr/bin/gawk -f

BEGIN {
  weekend[1]["0000"]["0659"] = "You should be recovering from the weekend"
  weekend[1]["0700"]["1759"] = "Get to work!"
  weekend[1]["1800"]["2159"] = "The week has just begun"
  weekend[1]["2200"]["2359"] = "First day is almost over"

  weekend[2]["0000"]["0659"] = "The dawn of a new day"
  weekend[2]["0700"]["1759"] = "The weekend is a long way off"
  weekend[2]["1800"]["2159"] = "Nearing the midweek"
  weekend[2]["2200"]["2359"] = "Go to bed!"

  weekend[3]["0000"]["0659"] = "Bhwuuuuuu"
  weekend[3]["0700"]["1759"] = "Half way there"
  weekend[3]["1800"]["2159"] = "The worst is almost over"
  weekend[3]["2200"]["2359"] = "The week is over the top"

  weekend[4]["0000"]["0659"] = "*grunt*"
  weekend[4]["0700"]["1759"] = "Hold on a little longer"
  weekend[4]["1800"]["2159"] = "Come on, you can do this"
  weekend[4]["2200"]["2359"] = "One more day to go"

  weekend[5]["0000"]["0659"] = "Making the last spurt"
  weekend[5]["0700"]["1759"] = "Weekend is neigh upon us!"
  weekend[5]["1800"]["2159"] = "Put on your party hat"
  weekend[5]["2200"]["2359"] = "And your party pyjama's"

  weekend[6]["0000"]["0659"] = "zZzzzZzzZzZZZzzZZzzzz"
  weekend[6]["0700"]["1759"] = "Yay!"
  weekend[6]["1800"]["2159"] = "Party time!"
  weekend[6]["2200"]["2359"] = "What will we do tomorrow?"

  weekend[7]["0000"]["0659"] = "ZZZZzzzZzzZzZZZzzZZzzz"
  weekend[7]["0700"]["1759"] = "Enjoying it while it lasts"
  weekend[7]["1800"]["2159"] = "Oh no! It's almost over!"
  weekend[7]["2200"]["2359"] = "Do I _have_ to go to bed?"
}

{
  day = ($1!="")?$1:strftime("%u")
  time = ($2!="")?$2:strftime("%H%M")

  for (start in weekend[day])
    for (end in weekend[day][start])
      if ( (time >= start) && (time <= end) )
        print weekend[day][start][end]

}
