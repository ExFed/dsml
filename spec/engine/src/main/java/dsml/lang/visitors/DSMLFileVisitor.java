package dsml.lang.visitors;

import dsml.lang.DSMLBaseVisitor;
import dsml.lang.DSMLParser;

import java.util.Collections;
import java.util.List;
import java.util.Objects;
import java.util.function.Function;
import java.util.stream.Collectors;
import java.util.stream.Stream;

public class DSMLFileVisitor extends DSMLBaseVisitor<List<StringTriple>> {

    @Override
    public List<StringTriple> visitFile(DSMLParser.FileContext ctx) {
        List<DSMLParser.ExpressionContext> entryContexts = ctx.expression();

        Stream<StringTriple> specifications =
                handle(entryContexts, DSMLParser.ExpressionContext::specification, this::handleSpecification);

        Stream<StringTriple> properties =
                handle(entryContexts, DSMLParser.ExpressionContext::property, this::handleProperty);

        return Stream.of(properties, specifications)
                .flatMap(Function.identity())
                .collect(Collectors.toList());
    }

    @Override
    public List<StringTriple> visitExpression(DSMLParser.ExpressionContext ctx) {
        // should've been handled by #visitFile
        return Collections.emptyList();
    }

    private <C> Stream<StringTriple> handle(List<DSMLParser.ExpressionContext> entryContext,
                                            Function<DSMLParser.ExpressionContext, C> selector,
                                            Function<C, StringTriple> handler) {
        return entryContext.stream()
                .map(selector)
                .filter(Objects::nonNull)
                .map(handler);
    }

    private StringTriple handleSpecification(DSMLParser.SpecificationContext ctx) {
        // just return some placeholders for now...
        return new StringTriple("some", "cool", "spec");
    }

    private StringTriple handleProperty(DSMLParser.PropertyContext ctx) {
        // just return some placeholders for now...
        return new StringTriple("awesome", "sauce", "property");
    }
}
