#let keywords = (
	"PHINIX+", "CPU",
	"Instruction Set",
	"Computer Engineering",
	"Computer Architecture"
)

#import "/source/template.typ": template
#show: x => template("Part 1: The CPU", "0.2.5", keywords, x)

#import "preface.typ": preface; #preface
#import "intro.typ": intro; #intro
