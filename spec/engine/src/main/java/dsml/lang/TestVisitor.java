package dsml.lang;

import dsml.lang.DSMLParser.SpecificationContext;
import dsml.lang.DSMLParser.SpecifierContext;
import org.antlr.v4.runtime.tree.TerminalNode;

import java.util.List;
import java.util.StringJoiner;

public class TestVisitor extends DSMLBaseVisitor<String> {

    @Override
    public String visitFile(DSMLParser.FileContext ctx) {
        StringJoiner sj = new StringJoiner("\n");
        for (DSMLParser.ExpressionContext entryContext : ctx.expression()) {
            sj.add(entryContext.accept(this));
        }
        return sj.toString();
    }

    @Override
    public String visitSpecification(SpecificationContext ctx) {
        List<TerminalNode> ids = ctx.ID();
        TerminalNode type = ids.get(0);
        TerminalNode name = ids.get(1);
        String spec = ctx.specifier().accept(this);
        return name + " --[ " + type + " ]-> " + spec;
    }

    @Override
    public String visitSpecifier(SpecifierContext ctx) {
        return ctx.ID().getText();
    }
}
