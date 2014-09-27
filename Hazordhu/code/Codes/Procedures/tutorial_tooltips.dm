



/*
mob/player
	verb/bux(n as num)
		set desc = "(page) Start the BUX tutorial from any page. (1-13)"
		n = clamp(n, 1, BUX.len)

		winshow(src, "bux")

		var out = "tooltip_output"
		src << output(null, out)
		src << output(BUX[n], out)

		n ++
		if(n < BUX.len)
			winset(src, "bux_next", "is-visible=true; command='bux [n]'")
		else winshow(src, "bux_next", FALSE)


var tooltips[] = list(
{"
These are your stats.  They tell you everything about your character.
<b>Health</b> shows the overall condition of your character.  If this bar empties completely, you die.
<b>Stamina</b> shows how tired you are.  If this bar empties completely, you will pass out from exhaustion.
Health and Stamina recover automatically over time.
<b>Hunger</b> and <b>Thirst</b> will go up over time.  Eat and drink regularly to keep them low.  If either of them fills, you will start dying.
<b>Heat</b> shows how hot or cold you are.  Keeping this bar <b>green</b> will keep you from freezing or overheating, both of which result in death.
<b>Blood</b> shows how much blood you have.  You only lose blood in battle.  Total blood loss will kill you.
"},

{"
This is the chat panel
<b>OOC</b> stands for Out of Character.  Use this to talk to everyone online.
	The checkbox beside OOC can be used to toggle whether or not you hear OOC.
<b>Yell</b> will make your text bold, and broadcast to everyone nearby, even if they aren't on your screen.
<b>Say</b> broadcasts your message to everyone in your view.
<b>Whisper</b> broadcasts you message in <i>Italics</i>  to everyone who is right beside you.
<b>Emote</b> is used to perform specific actions, and broadcasts to your view.
<b>Language</b> is used to change the language you are speaking.
"},

{"
<b>Barter!</b>
Bartering is simple:  Choose items from the shopkeeper you want, and the items you will trade in return.  This is done by clicking and dragging the items from the Shopkeepers contents into their Barter slot, and doing the same with items from your inventory.

<b>Remember!</b> The value of your items must be the same or higher than the value of the shopkeepers items.

When you're satisfied with the trade, click <i>Accept</i>  to finalize it.  If you wish to cancel the trade at any time, click <i>Decline</i> .

You can hold the alt key when dragging items to the barter screen to drag up to 10 of the same item.
"}
)

var BUX[] = bux()
proc/bux() return BUX || list(
{"
<u><b>Welcome to Hazordhu II!</b></u>
You're probably wondering where you are.  That's easy, you're in Hazordhu!
I'm the <b>BUX Tutorial</b>.  I will explain the basics of the game to you, so you can enjoy it to its fullest extent!  We'll start off by going over the controls and the interface.


Click 'Next' to continue.
"},

{"<u><b>The Interface</b></u>
In the top left you have your <b>screen</b>.  This shows you everything around you, and is how you interact with your world.
To the right of the screen is the <b>chat</b>.  Here you communicate with the other players in the world through chat and emotes (text actions).
To the bottom of the screen you will see <b>six bars</b>, and to the left of it several buttons and your inventory.  This is the <b>Character</b> section.

On the next page, we'll look at the stats.
"},

{"<u><b>Status</b></u>
Let's look at these bars down below.
<b>Health</b> shows the overall condition of your character.  If this bar empties completely, you will die.
<b>Stamina</b> shows how tired you are.  You need stamina to run and goes down while running, or if you are too hungry or thirsty.
<b>Hunger</b> and <b>Thirst</b> will go up over time.  Eat and drink regularly to keep them low.  If either of them fills, you will start dying.

Health and Stamina recover automatically over time.

Next we'll go over the other two bars.
"},

{"<u><b>Status (continued)</b></u>
<b>Heat</b> shows how hot or cold you are.  Keeping this bar <b>green</b> will keep you from freezing or overheating, both of which result in death.  You won't take any heat damage in the tutorial area, and where you go after will be the right temperature for you to thrive in.
<b>Blood</b> shows how much blood you have.  You only lose blood in battle.  Total blood loss will kill you.

Next we'll move on to the <b>Character</b> section.
"},

{"<u><b>My Character!</b></u>
In this pane on the bottom-right of your screen, you have several tabs.
<b>Items</b> shows your inventory and equipment panes, and is where you go to drop, use, or equip items.
<b>Skills</b> is where you go to create things.  Double clicking an item here will create, if you have enough resources and the proper tool.  Hover over these items to see what they require. Your cursor over them shows the tool you need.
We'll cover the <b>Group</b> panel in a bit.

Open your inventory up and equip the <b>hatchet</b> (drag it to the equipment pane) before moving on.

"},

{"<u><b>Welcome to the Tutorial Area!</b></u>
Now, let's go into the building southeast of where you just spawned.

In here you will see three people.  These people aren't players, and are referred to as <b>NPCs</b>.

Talk to them by facing them and pressing E.  Each will explain one of the three basic skills: <b>Gathering</b>, <b>Building</b>, and <b>Processing</b>.

Once you've spoken to all three of them, click 'Next'.
"},

{"<u><b>Getting Warmer!</b></u>
Now that you've spoken to all three of the NPCs let's go learn how to make something.

In the building further to the south there is a blacksmith.  Talk to him and he will tell you how to make things using the blacksmithing skill.

Once you've spoken to him, head down the path to the <b>temple</b> and talk to the NPC there.

"},

{"<u><b>The Aels!</b></u>
Aels were once the only race in the world, and in the thousands of aeons since the world of Hazordhu began, they have grown out of the need for a mortal body.

When you get right down to it, Aels are the staff of Hazordhu presented in a fashion that fits with roleplaying.  If you ever see a ghost running around, chances are that it's an Ael.

Let's move on to some fun stuff.  Click 'Next'.
"},

{"<u><b>Languages!</b></u>

Humans and Orcs both come from different <b>heritages</b>.
Each human heritage has its own language, the Orc race has its own language, and then there is Common.  Languages are only applied to <b>Say, Yell, and Whisper</b>.  Different types of chat will be explained on the next page.

To attempt to learn some of another language you will have to <b>hear someone speak it</b> first.  Once you've heard it spoken, open the <b>Learn Language</b> menu, select the language you wish to learn, select the letter, and type in your guess.  If it's correct, you'll have learned the letter!
"},

{"<u><b>Hello World!</b></u>
To chat, type into the bar on the bottom-left, and press Enter.  This will send the message depending on the selected channel.
There are five ways to communicate.  Click the "Chat" button to change the chat channel.
<b>OOC</b> stands for Out of Character.  Use this to talk to everyone online.
<b>Yell</b> will make your text bold, and broadcast to everyone nearby, even if they aren't on your screen.
<b>Say</b> broadcasts your message to everyone in your view.
<b>Whisper</b> broadcasts you message in <i>Italics</i>  to everyone who is right beside you.
<b>Emote</b> is used to perform specific actions, and broadcasts to your view.
You can hit Enter to gain focus to the chat bar.
"},

{"<u><b>To Arms!</b></u>
Fighting can present itself in many forms in Hazordhu.  The most common form is in battle, but sometimes people will have duels with each other, or have to kill an animal for its materials.
If you click the map, your character does a little animation.  That is used to gather, or initiate actions.  Hold control to face your cursor, and to make your actions attacks instead.  Hold right click to block.
Archery is a little more advanced.  Right click to notch an arrow, then click to fire.  Right clicking with an arrow notched will un-notch it.
"},

{"<u><b>That's all there is to it!</b></u>
Those are the basics of Hazordhu for you.
Look around the Tutorial Area and talk to the remaining NPC's for some extra tips.
When you are done, step on the rune circle at the very south of the area and press E to go to the starter area for your race.
There are a couple <b>tooltip</b> buttons located around the interface.  These will explain things in greater detail.
If you have any further questions, feel free to ask using the OOC chat.
<b><u>Have fun!</b></u>
"}
)
*/