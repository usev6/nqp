class QAST::Stmts is QAST::Node {
    has $!resultchild;

    method resultchild(*@value) { $!resultchild := @value[0] if @value; $!resultchild }
    
    method substitute_inline_placeholders(@fillers) {
        my $result := pir::repr_clone__PP(self);
        my $i := 0;
        my $elems := +@(self);
        while $i < $elems {
            $result[$i] := self[$i].substitute_inline_placeholders(@fillers);
            $i := $i + 1;
        }
        $result
    }
}
