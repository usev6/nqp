class QAST::Stmts is QAST::Node does QAST::Children {
    has $!resultchild;

    method new(*@children, *%options) {
        my $node := nqp::create(self);
        nqp::bindattr($node, QAST::Stmts, '@!children', @children);
        $node.set(%options) if %options;
        $node
    }

    method resultchild($value = NO_VALUE) {
        $value =:= NO_VALUE
          ?? $!resultchild
          !! ($!resultchild := $value)
    }

    method count_inline_placeholder_usages(@usages) {
        my int $elems := nqp::elems(@(self));
        my int $i := -1;
        while ++$i < $elems {
            self[$i].count_inline_placeholder_usages(@usages);
        }
    }

    method substitute_inline_placeholders(@fillers) {
        my $result := self.shallow_clone();
        my $elems := nqp::elems(@(self));
        my int $i := -1;
        while ++$i < $elems {
            $result[$i] := self[$i].substitute_inline_placeholders(@fillers);
        }
        $result
    }

    method evaluate_unquotes(@unquotes) {
        my $result := self.shallow_clone();
        my $elems := nqp::elems(@(self));
        my int $i := -1;
        while ++$i < $elems {
            $result[$i] := self[$i].evaluate_unquotes(@unquotes);
        }
        $result
    }

    method dump_extra_node_info() {
        nqp::defined($!resultchild) ?? ":resultchild($!resultchild))" !! ''
    }
}
