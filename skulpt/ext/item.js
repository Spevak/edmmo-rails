//Definitions for the python builtin types item and inventory.

/**
 * @constructor
 * @param {string} itemType the name of the type of item (e.g. potato)
 * @param {number} itemId the id number of this particular item instance
 * @extends Sk.builtin.object
 */
Sk.builtin.item = function(itemType, itemId, attributes) {
    if (!(this instanceof Sk.builtin.item)) return new Sk.builtin.item(itemType, itemId, {});

    var attr;
    if (attributes === undefined) {
	attr = {};
    } else {
	attr = attributes;
    }

    this.v = {type: itemType, id: itemId, attributes: attr};

    this.__class__ = Sk.builtin.item;

    this["v"] = this.v;
    return this;
};

Sk.builtin.item.prototype.ob$type = Sk.builtin.type.makeIntoTypeObj('item', Sk.builtin.item);

Sk.builtin.item.tp$name = "item";
Sk.builtin.item.prototype['$r'] = function() {
    return new Sk.builtin.str("Item: <type = " + this.v['type'] + ", id = " + this.v['id'].toString() + ">");
}

Sk.builtin.item.prototype.tp$getattr = Sk.builtin.object.prototype.GenericGetAttr;
Sk.builtin.item.prototype.tp$hash = Sk.builtin.object.prototype.HashNotImplemented;

goog.exportSymbol("Sk.builtin.item", Sk.builtin.item);
