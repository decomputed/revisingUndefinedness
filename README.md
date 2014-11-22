### Revising Undefinedness in the Well-Founded Semantics of Logic Programs

The Well-Founded Semantics (WFS) for normal logic programs associates with each program one single model expressing truth, falsity and undefinedness of atoms. Under the WFS, atoms are said to be undefined if:

* Either are part of a two-valued choice (true in some worlds, false in others) but never undeniably true or false;
* Or are not classically supported;
* Or depend on an already undefined literal, as in one of the previous cases.

Undefinedness due to lack of classical support could be overcome by the introduction of another form of support, which would allow the WFS to deal with programs requiring other forms of reasoning besides the classical support, and thus gain expressiveness. One of these forms of support whose application has already been studied in the Revised Stable Models semantics (rSMs) is support by reductio ad absurdum (RAA). This principle states that an hypothesis should be true if by assuming it’s false this assumption leads to a contradition.

In this thesis we propose to study the application of the RAA principle to the WFS, thus defining the Revised Well-Founded Semantics (RWFS). Besides this definition we’ll also study the definition of a fixed-point operator Γr , a counterpart of Gelfond-Lifschitz operator Γ, with support for RAA reasoning, and use this operator to perform the calculation of rSMs and the revised well-founded model of normal logic programs. We will also study a new property of rSMs and the definition of the revised partial stable models.

This thesis concludes with the discussion of several open issues and possible next research paths.

#### How to build the thesis

You're going to need the portuguese language babel package. If you're using TeXlive, you can install it with:

		tlmgr init-usertree
		tlmgr update -all
		tlmgr install babel-portuges

To build the PDF of the thesis you do:

		make clean pdf
