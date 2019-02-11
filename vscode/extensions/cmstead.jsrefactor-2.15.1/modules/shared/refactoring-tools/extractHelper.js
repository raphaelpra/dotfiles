'use strict';

function extractHelper(
    coordsHelper,
    scopePathHelper,
    selectionExpressionHelper,
    typeHelper
) {

    function getScopePath(editorCoords, ast) {
        const astCoords = coordsHelper.coordsFromEditorToAst(editorCoords);

        return scopePathHelper.buildScopePath(astCoords, ast);
    }

    const isScopeType =
        (nodeType) =>
            (astNode) =>
                astNode.type.toLowerCase().indexOf(nodeType) > -1;

    const isObjectScope = isScopeType('object');
    const isProgramScope = isScopeType('program');

    const isMethodDefinition = (node) => node.type === 'MethodDefinition';

    function getNewExtractionLocation(scopePath, selectedOptionIndex, selectionCoords, ast) {
        const selectedNode = scopePath[selectedOptionIndex];

        const currentScope = isMethodDefinition(selectedNode)
            ? selectedNode.value
            : selectedNode;
            
        const nextScope = scopePath[selectedOptionIndex + 1];

        const selectionAstCoords = coordsHelper.coordsFromEditorToAst(selectionCoords);
        const isLocalScope = typeof nextScope === 'undefined';

        let destinationExpression;

        if (isLocalScope) {
            destinationExpression = selectionExpressionHelper.getNearestExpressionInScope(currentScope.loc, selectionAstCoords, ast);
        } else {
            destinationExpression = selectionExpressionHelper.getNearestExpressionInScope(currentScope.loc, nextScope.loc, ast);
        }

        let destinationEditorCoords = coordsHelper.coordsFromAstToEditor(destinationExpression.loc);

        return {
            start: [destinationEditorCoords.start[0], destinationEditorCoords.start[1]],
            end: [destinationEditorCoords.start[0], destinationEditorCoords.start[1]]
        };
    }

    return {
        getNewExtractionLocation: typeHelper.enforce(
            'scopePath, selectedOptionIndex => editorCoords',
            getNewExtractionLocation),

        getScopePath: typeHelper.enforce(
            'editorCoords, ast => array<astNode>',
            getScopePath),

        isObjectScope: typeHelper.enforce(
            'astNode => boolean',
            isObjectScope),

        isProgramScope: typeHelper.enforce(
            'astNode => boolean',
            isProgramScope),

    }
}

module.exports = extractHelper;