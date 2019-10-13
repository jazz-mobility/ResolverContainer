//
//  ResolverContainerTests.swift
//  ResolverTests
//
//  Created by Natan Zalkin on 02/08/2019.
//  Copyright © 2019 Natan Zalkin. All rights reserved.
//

import Quick
import Nimble

@testable import ResolverContainer

class TestTest<Value> {}

typealias TestValue = TestTest<Int>

class ResolverContainerTests: QuickSpec {
    override func spec() {
        describe("ResolverContainer") {
            var container: ResolverContainer!

            beforeEach {
                container = ResolverContainer()
            }

            context("when registered resolver") {

                var instance: TestValue!

                beforeEach {
                    let object = TestValue()
                    instance = object
                    container.register { object }
                }

                it("can resolve it later") {
                    expect(try! container.resolve(TestValue.self)).to(beIdenticalTo(instance))

                    let object: TestTest<Int> = try! container.resolve()
                    expect(object).to(beIdenticalTo(instance))
                }

                context("when merged with another container") {

                    var another: ResolverContainer!

                    beforeEach {
                        another = ResolverContainer {
                            $0.register(instance: TestValue())
                        }
                    }

                    context("by replacing registered resolvers") {
                        beforeEach {
                            container.merge(with: another, preservingRegisteredResolvers: false)
                        }

                        it("replaces exiting resolver with the new form another container") {
                            expect(try! container.resolve(TestValue.self)).to(beIdenticalTo(try! another.resolve(TestValue.self)))
                        }
                    }

                    context("by preserving registered resolvers") {
                        beforeEach {
                            container.merge(with: another, preservingRegisteredResolvers: true)
                        }

                        it("replaces exiting resolver with the new form another container") {
                            expect(try! container.resolve(TestValue.self)).toNot(beIdenticalTo(try! another.resolve(TestValue.self)))
                        }
                    }
                }

                context("and unregistered object") {

                    beforeEach {
                        container.unregister(TestTest<Int>.self)
                    }

                    it("fails to resolve the type") {
                        do {
                            let _ = try container.resolve(TestValue.self)
                        } catch {
                            expect(error).to(matchError(ResolverContainer.Error.unregisteredType("TestTest<Int>")))
                        }

                        do {
                            let _: TestTest<Int> = try container.resolve()
                        } catch {
                            expect(error).to(matchError(ResolverContainer.Error.unregisteredType("TestTest<Int>")))
                        }
                    }
                }
            }

            context("when registered instance") {

                var instance: TestValue!

                beforeEach {
                    let object = TestValue()
                    instance = object
                    container.register(instance: object)
                }

                it("can resolve it later") {
                    expect(container[TestValue.self]).to(beIdenticalTo(instance))

                    let object: TestTest<Int> = try! container.resolve()
                    expect(object).to(beIdenticalTo(instance))
                }

                context("and unregistered object") {

                    beforeEach {
                        container.unregister(TestValue.self)
                        container.unregister(TestTest<Int>.self)
                    }

                    it("fails to resolve the type") {
                        do {
                            let _ = try container.resolve(TestValue.self)
                        } catch {
                            expect(error as? ResolverContainer.Error).to(equal(ResolverContainer.Error.unregisteredType("TestTest<Int>")))
                        }

                        do {
                            let _ = try container.resolve(TestTest<Int>.self)
                        } catch {
                            expect(error as? ResolverContainer.Error).to(equal(ResolverContainer.Error.unregisteredType("TestTest<Int>")))
                        }
                    }
                }

                context("and unregistered all objects") {

                    beforeEach {
                        container.unregisterAll()
                    }

                    it("fails to resolve any type") {
                        do {
                            let _ = try container.resolve(TestValue.self)
                        } catch {
                            expect(error as? ResolverContainer.Error).to(equal(ResolverContainer.Error.unregisteredType("TestTest<Int>")))
                        }

                        do {
                            let _ = try container.resolve(TestTest<Int>.self)
                        } catch {
                            expect(error as? ResolverContainer.Error).to(equal(ResolverContainer.Error.unregisteredType("TestTest<Int>")))
                        }
                    }
                }
            }
        }
    }
}
