package aquila.game.data;

import h2d.col.Point;
import hpp.util.GeomUtil.SimplePoint;

/**
 * ...
 * @author Krisztian Somoracz
 */
class AttackLineConfig
{
	static inline var scaleRatio:Float = 1;

	static var attackLines:Array<AttackLine> = [{id:'1512934043482',length:908,line:[{x:94,y:-94},{x:469,y:296},{x:263,y:731}]},{id:'1512934043483',length:937,line:[{x:1042,y:-94},{x:667,y:296},{x:873,y:731}]},{id:'1512943091470',length:2090,line:[{x:126,y:-60},{x:153,y:449},{x:549,y:476},{x:751,y:-13},{x:1182,y:335},{x:793,y:730}]},{id:'1512943091471',length:2088,line:[{x:1010,y:-60},{x:983,y:449},{x:587,y:476},{x:385,y:-13},{x:-46,y:335},{x:343,y:730}]},{id:'1512943197428',length:2196,line:[{x:570,y:-64},{x:585,y:299},{x:351,y:407},{x:62,y:223},{x:269,y:47},{x:1075,y:184},{x:807,y:708}]},{id:'1512943197429',length:2192,line:[{x:566,y:-64},{x:551,y:299},{x:785,y:407},{x:1074,y:223},{x:867,y:47},{x:61,y:184},{x:329,y:708}]},{id:'1512943374307',length:1944,line:[{x:-54,y:563},{x:1019,y:554},{x:1035,y:96},{x:473,y:135},{x:456,y:-47}]},{id:'1512943374308',length:1942,line:[{x:1190,y:563},{x:117,y:554},{x:101,y:96},{x:663,y:135},{x:680,y:-47}]},{id:'1515943561467',length:2284,line:[{x:-40,y:72},{x:286,y:414},{x:673,y:156},{x:978,y:223},{x:901,y:560},{x:493,y:527},{x:405,y:-77}]},{id:'1515943614082',length:2280,line:[{x:1176,y:72},{x:850,y:414},{x:463,y:156},{x:158,y:223},{x:235,y:560},{x:643,y:527},{x:731,y:-77}]},{id:'1515943623137',length:2508,line:[{x:48,y:707},{x:233,y:338},{x:741,y:372},{x:749,y:41},{x:312,y:43},{x:440,y:583},{x:1188,y:459}]},{id:'1515943697096',length:2504,line:[{x:1088,y:707},{x:903,y:338},{x:395,y:372},{x:387,y:41},{x:824,y:43},{x:696,y:583},{x:-52,y:459}]},{id:'1515943704736',length:2206,line:[{x:211,y:-40},{x:55,y:196},{x:176,y:599},{x:682,y:381},{x:247,y:87},{x:56,y:489},{x:540,y:716}]},{id:'1515943755950',length:2202,line:[{x:925,y:-40},{x:1081,y:196},{x:960,y:599},{x:454,y:381},{x:889,y:87},{x:1080,y:489},{x:596,y:716}]},{id:'1515943764621',length:1933,line:[{x:542,y:-73},{x:77,y:139},{x:355,y:477},{x:868,y:195},{x:1033,y:473},{x:650,y:736}]},{id:'1515943802836',length:1935,line:[{x:594,y:-73},{x:1059,y:139},{x:781,y:477},{x:268,y:195},{x:103,y:473},{x:486,y:736}]},{id:'1515943816533',length:2316,line:[{x:1056,y:698},{x:1071,y:66},{x:642,y:380},{x:132,y:55},{x:147,y:409},{x:449,y:438},{x:407,y:-51}]},{id:'1515943895147',length:2312,line:[{x:80,y:698},{x:65,y:66},{x:494,y:380},{x:1004,y:55},{x:989,y:409},{x:687,y:438},{x:729,y:-51}]},{id:'1515943903782',length:2268,line:[{x:-49,y:93},{x:383,y:65},{x:138,y:370},{x:187,y:563},{x:571,y:585},{x:598,y:114},{x:1057,y:269},{x:887,y:702}]},{id:'1515943970541',length:2266,line:[{x:1185,y:93},{x:753,y:65},{x:998,y:370},{x:949,y:563},{x:565,y:585},{x:538,y:114},{x:79,y:269},{x:249,y:702}]}];

	public static function getAttackLine(attackLineId:String):AttackLine
	{
		for (attackLine in attackLines)
		{
			if (attackLine.id == attackLineId)
			{
				return cloneAttackLine(attackLine);
			}
		}

		return null;
	}

	static function cloneAttackLine(baseAttackLine:AttackLine):AttackLine
	{
		var res:AttackLine = {
			id: baseAttackLine.id,
			length: baseAttackLine.length,
			line: []
		};

		for (point in baseAttackLine.line) res.line.push({ x: point.x * scaleRatio, y: point.y * scaleRatio });

		return res;
	}
}

typedef AttackLine = {
	var id:String;
	var length:Float;
	var line:Array<SimplePoint>;
}