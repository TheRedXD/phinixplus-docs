#let regfile = [

#import "/source/utilities.typ": note, comment

= Register Files
A register file is a grouping of individually addressable memory cells, also
known as registers, that are closely coupled with the operation and structure
of a processor architecture. PHINIX+ defines three of these register files,
each with a slightly different purpose. The first two of the novel features
outlined in @table-novelfeatures are thus explained in detail in this chapter.

#note[
	Registers are the most common subjects (also referred to as operands) of
	the instructions a CPU executes, especially if it follows the load-store
	paradigm wherein, as a consequence, no arithmetic/logic instruction can
	directly operate on memory.
]

== General Purpose Registers
The general purpose registers are a pair of register files, each file aimed
towards a narrower set of use cases. This is the first novel feature of
PHINIX+, initially noted in the first entry of @table-novelfeatures. Each file
consists of 16 registers for a total of 32 registers. The two register files
are to be detailed in the following two subsections and an extra subsection
listing out the registers in table form.

#comment[
	The quantity of general purpose registers PHINIX+ provides, 32, is a
	commonality amongst the majority of RISC processor architectures,
	consistently more than the usual CISC architecture. The reason for this
	is that having instructions that do less work would necessitate more
	space to store intermediate values in.
]

=== Data Registers
The data registers are the most versatile set of registers available. 16
are provided, each one being 32 bits in width, denoted #emph[\$xN] (where
N, a single hexadecimal digit ranging from 0 to 9 and then from A to F).
They are intended to store values loaded from or to be stored to memory and
to be the subject (operand) of most arithmetic and logic operations the CPU
performs.

#note[
	It is important to note that the first data register, #emph[\$x0] is not
	actually a register one can write to. Register #emph[\$x0] is a constant
	holding the value zero. This is a nigh universal design pattern across
	the RISC processor family and has been included in PHINIX+ for the same
	reasons.
]

#comment[
	Data register #emph[\$x0] being a constant zero aids in better usage of
	existing instructions (or conversely allows for the reduction of the needed
	instructions) in at least the following two ways:
	- #[By allowing them to discard their result by storing to this register
	when only the condition code generated from that instruction is required.
	For example, a comparison instruction can be achieved by doing a subtraction
	and storing the result to register zero.]
	- #[By allowing instructions that address memory to coalesce under a
	single addressing mode, "reg + imm". This is such because when supplying
	#emph[\$x0] as the register, the effective address becomes just the
	immediate, and by supplying a zero immediate the effective address becomes
	the supplied register. #footnote[Addressing modes as they relate to PHINIX+
	are discussed in TODO.]]
]

=== Address Registers
The address registers are a secondary set of registers that are less versatile
computation-wise than the data registers. Just like the data registers, 16 are
provided, again each one being 32 bits in width, denoted instead #emph[\$yN]
(where N, a single hexadecimal digit, ranging from 0 to 9 and then from A to F).

While still having more available functionality than for just storing and
manipulating pointers, the address registers' primary purpose is nevertheless
for the aforementioned task or as a bank of secondary storage when the data
registers are not enough to hold all datums of a computation.

#pagebreak()
=== Data and Address Register Tables
The defined registers are hereby illustrated in table form.

#figure(grid(columns: 2, gutter: 1em,
	table(columns: (40mm),
		table.header([Data Registers]),
		[\$x0], [\$x1], [\$x2], [\$x3], [\$x4], [\$x5], [\$x6], [\$x7],
		[\$x8], [\$x9], [\$xA], [\$xB], [\$xC], [\$xD], [\$xE], [\$xF],
	),
	table(columns: (40mm),
		table.header([Address Registers]),
		[\$y0], [\$y1], [\$y2], [\$y3], [\$y4], [\$y5], [\$y6], [\$y7],
		[\$y8], [\$y9], [\$yA], [\$yB], [\$yC], [\$yD], [\$yE], [\$yF]
	)
), caption: [PHINIX+'s general purpose registers]) <table-generalregs>

== Condition Code Registers
The condition code registers are the most special one of the bunch. 8 of
them are provided, each one being just 1 bit in width. They are denoted
#emph[\$cN] (where N, a single octal digit, ranging from 0 to 7). A condition
code register's purpose is to hold intermediate "flags", assisting in program
control flow. The branch instructions to be later discussed are intimately tied
with this set of registers. #footnote[Branch instructions and how they relate
to the condition code registers are discussed in TODO.]

#figure(table(columns: 1,
	table.header([Condition Code Registers]),
	[\$c0], [\$c1], [\$c2], [\$c3], [\$c4], [\$c5], [\$c6], [\$c7],
), caption: [PHINIX+'s condition code registers]) <table-condregs>

#comment[
	Condition code register #emph[\$c0] is a register that constantly and
	forever holds a zero bit. This simplifies the logic needed to handle
	a cascading set of conditions and reduces the amount of instructions
	required to handle all the needed cases.
]

#comment[
	Having eight condition code registers, each one being 1 bit in width means
	that saving and restoring the contents can be done in one fell swoop. The
	entire register file's contents can fit into a single byte. To aid in this
	mechanic, all of the registers have the same saving (with the exception of
	#emph[\$c0], on which saving is not applicable due to its constant nature).
]

== Register Calling Convention
The tables of registers previously showcased contained three columns. The first
one, labeled #emph[Architectural Name] denotes the systematic name given to the
register for the purposes of a hardware point-of-view. The other two columns
however, #emph[Convention Name] and #emph[Saving], concern a software
point-of-view instead. An implementer doesn't care how the registers are used
because they are all generic so they get generic architectural names. A
programmer however needs to organize the registers given to them in a consistent
manner in order to ensure proper behavior when calling into subroutines, thus a
#emph[convention] for #emph[calling], a pre-agreed set of rules to ensure
compatibility between interacting subroutines.

This document provides a reference, standard calling convention that any
software written for the processor is advised to use such that software written
by different developers can interoperate. Developers however are free to come
up with whatever alternative convention to better suit their needs, it just then
falls unto them to interface with other existing software which is not
compatible with their custom convention. A calling convention's whole purpose
is to provide a common ground for software development, so that someones's code
is able to use someone else's.

== Register File Conventions Tables
#figure(table(columns: 3,
	table.header([Architectural Name], [Convention Name], [Saving]),
	[\$x0], [\$zr], [N/A],
	[\$x1], [\$at], [Caller],
	[\$x2], [TBD], [TBD],
	[\$x3], [TBD], [TBD],
	[\$x4], [TBD], [TBD],
	[\$x5], [TBD], [TBD],
	[\$x6], [TBD], [TBD],
	[\$x7], [TBD], [TBD],
	[\$x8], [TBD], [TBD],
	[\$x9], [TBD], [TBD],
	[\$xA], [TBD], [TBD],
	[\$xB], [TBD], [TBD],
	[\$xC], [TBD], [TBD],
	[\$xD], [TBD], [TBD],
	[\$xE], [TBD], [TBD],
	[\$xF], [TBD], [TBD]
), caption: [PHINIX+'s data registers]) <table-dataregs>

#figure(table(columns: 3,
	table.header([Architectural Name], [Convention Name], [Saving]),
	[\$y0], [TBD], [TBD],
	[\$y1], [TBD], [TBD],
	[\$y2], [TBD], [TBD],
	[\$y3], [TBD], [TBD],
	[\$y4], [TBD], [TBD],
	[\$y5], [TBD], [TBD],
	[\$y6], [TBD], [TBD],
	[\$y7], [TBD], [TBD],
	[\$y8], [TBD], [TBD],
	[\$y9], [TBD], [TBD],
	[\$yA], [TBD], [TBD],
	[\$yB], [TBD], [TBD],
	[\$yC], [TBD], [TBD],
	[\$yD], [TBD], [TBD],
	[\$yE], [TBD], [TBD],
	[\$yF], [TBD], [TBD]
), caption: [PHINIX+'s address registers]) <table-addrregs>

#figure(table(columns: 3,
	table.header([Architectural Name], [Convention Name], [Saving]),
	[\$c0], [\$c0], [N/A],
	[\$c1], [\$c1], [Callee],
	[\$c2], [\$c2], [Callee],
	[\$c3], [\$c3], [Callee],
	[\$c4], [\$c4], [Callee],
	[\$c5], [\$c5], [Callee],
	[\$c6], [\$c6], [Callee],
	[\$c7], [\$c7], [Callee]
), caption: [PHINIX+'s condition code registers]) <table-condregs>

]
